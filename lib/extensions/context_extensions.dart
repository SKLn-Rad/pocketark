// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  //* Allow easy access to localizations via the context
  AppLocalizations? get localizations => AppLocalizations.of(this);
}
