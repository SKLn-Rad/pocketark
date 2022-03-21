import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../settings/state/settings_view_model.dart';
import '../../../enums/pocketark_timezone.dart';
import '../../../extensions/context_extensions.dart';
import '../../../constants/design_constants.dart';

class SettingsCardNotificationsSettings extends StatelessWidget {
  const SettingsCardNotificationsSettings({
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
              localizations?.pageSettingsComponentSettingsNotificationsHeading ?? '',
              textAlign: TextAlign.start,
              style: context.textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              localizations?.pageSettingsComponentSettingsNotificationsHelpNotifications ?? '',
              textAlign: TextAlign.start,
              style: context.textTheme.caption,
            ),
            const Divider(color: Colors.white),
            kSpacingSmall.asHeightWidget,
            Text(
              context.localizations!.pageSettingsComponentSettingsNotificationsTooltipMinutes(viewModel.notificationMinutes),
              style: context.textTheme.caption,
            ),
            Slider(
              value: viewModel.notificationMinutes.toDouble(),
              onChanged: (double val) => viewModel.notificationMinutes = val.floor(),
              min: 5,
              max: 60,
            ),
            kSpacingSmall.asHeightWidget,
            Align(
              alignment: Alignment.centerLeft,
              child: MaterialButton(
                color: context.theme.primaryColor,
                onPressed: viewModel.canSave ? viewModel.saveSettings : null,
                child: Text(context.localizations?.sharedActionsSave ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
