import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../events/events_updated_event.dart';
import '../../../events/timezone_updated_event.dart';
import '../../../extensions/context_extensions.dart';
import '../../../services/service_configuration.dart';

class SettingsViewModel extends BaseViewModel with PocketArkServiceMixin {
  StreamSubscription<EventsUpdatedEvent>? streamSubscriptionEvents;
  StreamSubscription<TimezoneUpdatedEvent>? streamSubscriptionTimezone;

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
