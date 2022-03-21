import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../events/adverts_updated_event.dart';
import '../../../constants/application_constants.dart';
import '../../../events/events_updated_event.dart';
import '../../../extensions/context_extensions.dart';
import '../../../services/service_configuration.dart';
import '../../../proto/events.pb.dart';
import '../../../structure/lost_ark_event_schedule.dart';

enum EventDropdownAction {
  selectDate,
  enableAllGlobalEventAlarms,
  disableAllGlobalEventAlarms,
  toggleHideEventsWithoutAlarms,
}

extension EventDropdownActionExtensions on EventDropdownAction {
  String toLocale(BuildContext context, {dynamic meta}) {
    final AppLocalizations? localizations = context.localizations;
    switch (this) {
      case EventDropdownAction.selectDate:
        return localizations!.pageEventsComponentsAppBarActionsSelectDate;
      case EventDropdownAction.enableAllGlobalEventAlarms:
        return localizations!.pageEventsComponentsAppBarActionsUnmuteAll;
      case EventDropdownAction.disableAllGlobalEventAlarms:
        return localizations!.pageEventsComponentsAppBarActionsMuteAll;
      case EventDropdownAction.toggleHideEventsWithoutAlarms:
        return meta == true ? localizations!.pageEventsComponentsAppBarActionsShowMuted : localizations!.pageEventsComponentsAppBarActionsHideMuted;
    }
  }
}

class EventsViewModel extends BaseViewModel with PocketArkServiceMixin {
  final TextEditingController searchController = TextEditingController();
  final List<LostArkEvent> filteredEvents = <LostArkEvent>[];

  StreamSubscription<EventsUpdatedEvent>? streamSubscriptionEvents;
  StreamSubscription<AdvertsUpdatedEvent>? streamSubscriptionAdverts;
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  BannerAd? _bannerAd;
  BannerAd? get bannerAd => _bannerAd;

  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String val) {
    _searchText = val;
    notifyListeners();
  }

  bool _hideEventsWithoutAlarms = false;
  bool get hideEventsWithoutAlarms => _hideEventsWithoutAlarms;
  set hideEventsWithoutAlarms(bool val) {
    _hideEventsWithoutAlarms = val;
    notifyListeners();
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    bootstrap();
  }

  Future<void> bootstrap() async {
    await streamSubscriptionAdverts?.cancel();
    await streamSubscriptionEvents?.cancel();
    streamSubscriptionAdverts = inqvine.getEventStream<AdvertsUpdatedEvent>().listen((_) => notifyListeners());
    streamSubscriptionEvents = inqvine.getEventStream<EventsUpdatedEvent>().listen(filterEvents);

    hideEventsWithoutAlarms = sharedPreferences.getBool(kSharedKeyHideEventsWithoutAlarms) ?? false;
    filterEvents(const EventsUpdatedEvent(shouldSort: true));
  }

  Future<void> onDropdownActionSelected(BuildContext context, EventDropdownAction? action) => handleAction(() async {
        if (action == null) {
          return;
        }

        'Handling action: $action'.logDebug();
        await Future<void>.delayed(const Duration(milliseconds: 250));

        switch (action) {
          case EventDropdownAction.selectDate:
            await onSetDateRequested(context);
            break;
          case EventDropdownAction.enableAllGlobalEventAlarms:
            await eventService.enableAllGlobalEventAlarms();
            break;
          case EventDropdownAction.disableAllGlobalEventAlarms:
            await eventService.disableAllGlobalEventAlarms();
            break;
          case EventDropdownAction.toggleHideEventsWithoutAlarms:
            await toggleHideMutedEvents();
            break;
        }
      });

  Future<void> toggleHideMutedEvents() async {
    'Toggling hide muted events to ${!hideEventsWithoutAlarms}'.logInfo();
    hideEventsWithoutAlarms = !hideEventsWithoutAlarms;
    await sharedPreferences.setBool(kSharedKeyHideEventsWithoutAlarms, hideEventsWithoutAlarms);
  }

  Future<void> onSetDateRequested(BuildContext context) async {
    final DateTime currentDateTime = DateTime.now().toUtc();
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: currentDateTime.subtract(const Duration(days: 7)),
      lastDate: currentDateTime.add(const Duration(days: 7)),
      builder: (_, Widget? child) {
        return Theme(
          data: Theme.of(context),
          child: child ?? Container(),
        );
      },
    );

    if (newDate == null) {
      return;
    }

    'Selected a new date: $newDate'.logInfo();
    selectedDate = newDate;
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: true));
  }

  Future<void> toggleEventMute(LostArkEvent event) => handleAction(() async {
        'Toggling mute of event: ${event.fallbackName}'.logInfo();
        final bool isGlobalEventAlarmActive = eventService.isGlobalEventAlarmActive(event);

        if (isGlobalEventAlarmActive) {
          await eventService.disableGlobalEventAlarm(event, shouldReschedule: true);
        } else {
          await eventService.enableGlobalEventAlarm(event, shouldReschedule: true);
        }
      });

  Future<void> filterEvents(EventsUpdatedEvent event) => handleAction(() async {
        notifyListeners();
        if (!event.shouldSort) {
          return;
        }

        final Duration currentHour = Duration(hours: DateTime.now().hour);
        final Duration currentMinute = Duration(minutes: DateTime.now().minute);
        final DateTime compareDateTime = selectedDate.add(currentHour).add(currentMinute);
        filteredEvents.clear();
        notifyListeners();

        for (final LostArkEventSchedule oldEventSchedule in eventService.eventSchedules.values) {
          final LostArkEvent newEvent = LostArkEvent.create()
            ..mergeFromMessage(oldEventSchedule.event)
            ..schedule.clear();

          for (final LostArkEvent_LostArkEventSchedule schedule in oldEventSchedule.event.schedule) {
            final int eventStartUtc = schedule.timeStart.toInt();
            final DateTime eventStartTime = DateTime.fromMillisecondsSinceEpoch(eventStartUtc);

            //* We can adjust offsets here for server time
            // compareDateTime.offset = +1
            // eventStartTime.offset = +1

            if (compareDateTime.ddMMyyyy == eventStartTime.ddMMyyyy) {
              newEvent.schedule.add(schedule);
            }
          }

          if (newEvent.schedule.isNotEmpty) {
            newEvent.schedule.sort(
              (a, b) {
                return a.timeStart.compareTo(b.timeStart);
              },
            );

            final DateTime eventStartTime = DateTime.fromMillisecondsSinceEpoch(newEvent.schedule.last.timeStart.toInt());
            final DateTime timeNow = DateTime.now();
            final Duration difference = eventStartTime.difference(timeNow);
            //? Check that there is at least one event in the near future
            if (difference >= Duration.zero) {
              filteredEvents.add(newEvent);
            }
          }
        }

        //* Sort by item level
        filteredEvents.sort(
          (a, b) {
            final int aValue = a.type * 10000 + a.recItemLevel;
            final int bValue = b.type * 10000 + b.recItemLevel;
            return aValue.compareTo(bValue);
          },
        );

        'Filtered events successfully'.logInfo();
      });
}
