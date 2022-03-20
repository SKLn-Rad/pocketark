// Package imports:
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/enums/pocketark_timezone.dart';
import 'package:pocketark/events/timezone_updated_event.dart';
import 'package:pocketark/services/service_configuration.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/application_constants.dart';

class SystemService extends InqvineServiceBase with PocketArkServiceMixin {
  PocketArkTimezone _timezone = PocketArkTimezone.usWest;
  PocketArkTimezone get timezone => _timezone;

  @override
  Future<void> initializeService() async {
    await loadPreferences();
    await super.initializeService();
  }

  Future<void> loadPreferences() async {
    'Attempting to loading Timezone'.logDebug();
    if (sharedPreferences.containsKey(kSharedKeySettingsTimezone)) {
      _timezone = PocketArkTimezone.values.where((element) => element.name == sharedPreferences.getString(kSharedKeySettingsTimezone)).first;
      inqvine.publishEvent(TimezoneUpdatedEvent());
    }
  }

  Future<void> openUrl(String url) async {
    'Attempting to open: $url'.logInfo();
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> resetCache() async {
    'Resetting cache'.logInfo();
    await sharedPreferences.clear();
  }

  Future<void> updateTimezone(PocketArkTimezone newTimezone) async {
    'Updating timezone to $newTimezone'.logInfo();
    _timezone = newTimezone;

    await sharedPreferences.setString(kSharedKeySettingsTimezone, newTimezone.name);
    inqvine.publishEvent(TimezoneUpdatedEvent());
  }
}
