import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../events/events_updated_event.dart';
import '../../../events/timezone_updated_event.dart';
import '../../../services/service_configuration.dart';
import '../../../proto/events.pb.dart';

class EventsViewModel extends BaseViewModel with PocketArkServiceMixin {
  StreamSubscription<EventsUpdatedEvent>? streamSubscriptionEvents;
  StreamSubscription<TimezoneUpdatedEvent>? streamSubscriptionTimezone;

  List<LostArkEvent> get allEvents => eventService.events.values.toList();
  List<LostArkEvent> get filteredEvents {
    final Duration currentHour = Duration(hours: DateTime.now().toUtc().hour);
    final Duration currentMinute = Duration(minutes: DateTime.now().toUtc().minute);
    final DateTime compareDateTime = shownDateTime.add(currentHour).add(currentMinute);

    final List<LostArkEvent> newEvents = <LostArkEvent>[];
    for (final LostArkEvent oldEvent in allEvents) {
      final LostArkEvent newEvent = LostArkEvent.create()
        ..mergeFromMessage(oldEvent)
        ..schedule.clear();

      for (final LostArkEvent_LostArkEventSchedule schedule in oldEvent.schedule) {
        final DateTime eventStartTime = DateTime.fromMillisecondsSinceEpoch(schedule.timeStart.toInt());
        final Duration difference = eventStartTime.difference(compareDateTime);
        //! This only looks at +- 12 hours, could be setting
        if (difference.inHours.abs() <= 12) {
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
          newEvents.add(newEvent);
        }
      }
    }
    newEvents.sort(
      (a, b) {
        int aValue = a.type * 10000 + a.recItemLevel;
        int bValue = b.type * 10000 + b.recItemLevel;
        return aValue.compareTo(bValue);
      },
    );
    return newEvents;
  }

  DateTime _shownDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toUtc();
  DateTime get shownDateTime => _shownDateTime;
  set shownDateTime(DateTime time) {
    _shownDateTime = time;
    notifyListeners();
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    bootstrap();
  }

  Future<void> bootstrap() async {
    await streamSubscriptionEvents?.cancel();
    await streamSubscriptionTimezone?.cancel();
    streamSubscriptionEvents = inqvine.getEventStream<EventsUpdatedEvent>().listen((_) => notifyListeners());
    streamSubscriptionTimezone = inqvine.getEventStream<TimezoneUpdatedEvent>().listen((_) => notifyListeners());
  }

  Future<void> onSetDateRequested(BuildContext context) async {
    final DateTime currentDateTime = DateTime.now().toUtc();
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: shownDateTime,
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
    shownDateTime = newDate;
  }
}
