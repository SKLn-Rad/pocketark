import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../constants/application_constants.dart';
import '../../../events/events_updated_event.dart';
import '../../../extensions/context_extensions.dart';
import '../../../services/service_configuration.dart';

class SettingsViewModel extends BaseViewModel with PocketArkServiceMixin {
  StreamSubscription<EventsUpdatedEvent>? streamSubscriptionEvents;

  bool _canSave = false;
  bool get canSave => _canSave;

  int _notificationMinutes = 5;
  int get notificationMinutes => _notificationMinutes;
  set notificationMinutes(int val) {
    _notificationMinutes = val;
    _canSave = true;
    notifyListeners();
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    bootstrap();
  }

  Future<void> bootstrap() async {
    await streamSubscriptionEvents?.cancel();
    streamSubscriptionEvents = inqvine.getEventStream<EventsUpdatedEvent>().listen((_) => notifyListeners());

    if (sharedPreferences.containsKey(kSharedKeyNotificationPreTime)) {
      notificationMinutes = sharedPreferences.getInt(kSharedKeyNotificationPreTime) ?? 5;
    }
  }

  Future<void> saveSettings() async {
    if (!canSave) {
      return;
    }

    await sharedPreferences.setInt(kSharedKeyNotificationPreTime, notificationMinutes);
    _canSave = false;
    notifyListeners();

    unawaited(eventService.scheduleNotifications());
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
          content: Text(localizations.pageSettingsComponentSettingsResetCacheBody),
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
