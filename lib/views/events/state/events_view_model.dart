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

  DateTime _shownDateTime = DateTime.now().toUtc();
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

    //* Set HMS as current
    newDate = newDate.add(Duration(hours: currentDateTime.hour));
    newDate = newDate.add(Duration(hours: currentDateTime.minute));
    newDate = newDate.add(Duration(hours: currentDateTime.second));

    'Selected a new date: $newDate'.logInfo();
    shownDateTime = newDate;
  }
}
