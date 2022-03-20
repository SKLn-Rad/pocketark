import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/events/events_updated_event.dart';
import 'package:pocketark/events/timezone_updated_event.dart';
import '../../../extensions/context_extensions.dart';
import '../../../services/service_configuration.dart';
import '../../../proto/events.pb.dart';

class HomeViewModel extends BaseViewModel with PocketArkServiceMixin {
  final PageController currentPageController = PageController(initialPage: 1);

  StreamSubscription<EventsUpdatedEvent>? streamSubscriptionEvents;
  StreamSubscription<TimezoneUpdatedEvent>? streamSubscriptionTimezone;

  int _currentHomeIndex = 1;
  int get currentHomeIndex => _currentHomeIndex;

  DateTime _shownDateTime = DateTime.now().toUtc();
  DateTime get shownDateTime => _shownDateTime;
  set shownDateTime(DateTime time) {
    _shownDateTime = time;
    notifyListeners();
  }

  List<LostArkEvent> get allEvents => eventService.events.values.toList();

  Future<void> onPageUpdated(int index, {bool shouldAttemptAnimate = true}) async {
    final int delta = max(index, _currentHomeIndex) - min(index, _currentHomeIndex);
    if (shouldAttemptAnimate && delta == 1) {
      currentPageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.decelerate);
    } else if (shouldAttemptAnimate) {
      currentPageController.jumpToPage(index);
    } else {
      _currentHomeIndex = index;
    }

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

  Future<void> onResetCacheRequested(BuildContext context) async {
    final AppLocalizations? localizations = context.localizations;
    if (localizations == null) {
      return;
    }

    await systemService.resetCache();
    await showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text(localizations.sharedDialogsHeadingsSuccess),
          content: Text(localizations.pageHomeComponentSettingsResetCacheBody),
          actions: <Widget>[
            CupertinoButton(
              child: Text(localizations.sharedActionsContinue),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
