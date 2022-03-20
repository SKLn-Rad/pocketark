import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../views/settings/state/settings_view_model.dart';
import '../../../extensions/context_extensions.dart';
import '../../../constants/design_constants.dart';

class SettingsCardSystemSettings extends StatelessWidget {
  const SettingsCardSystemSettings({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? localizations = context.localizations;
    return Card(
      color: kGrayDark,
      child: Container(
        padding: kSpacingMedium.asPaddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations?.pageSettingsComponentSettingsSystemHeading ?? '',
              textAlign: TextAlign.start,
              style: context.textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              localizations?.pageSettingsComponentSettingsSystemSubheading ?? '',
              textAlign: TextAlign.start,
              style: context.textTheme.caption,
            ),
            const Divider(color: Colors.white),
            kSpacingSmall.asHeightWidget,
            Align(
              alignment: Alignment.centerLeft,
              child: MaterialButton(
                color: Colors.red,
                onPressed: () => viewModel.onResetCacheRequested(context),
                child: Text(
                  localizations?.pageSettingsComponentSettingsButtonResetCache ?? '',
                  style: context.textTheme.button!.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
