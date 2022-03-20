import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../extensions/context_extensions.dart';

enum PocketArkTimezone { usWest, usEast, euCentral, euWest, southAmerica }

extension PocketArkTimezoneExtensions on PocketArkTimezone {
  String toLocale(BuildContext context) {
    final AppLocalizations? localizations = context.localizations;
    if (localizations == null) {
      return '';
    }

    switch (this) {
      case PocketArkTimezone.usWest:
        return localizations.sharedTimezonesUSWest;
      case PocketArkTimezone.usEast:
        return localizations.sharedTimezonesUSEast;
      case PocketArkTimezone.euCentral:
        return localizations.sharedTimezonesEUCentral;
      case PocketArkTimezone.euWest:
        return localizations.sharedTimezonesEUWest;
      case PocketArkTimezone.southAmerica:
        return localizations.sharedTimezonesSA;
    }
  }
}
