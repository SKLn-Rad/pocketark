import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../enums/pocketark_timezone.dart';
import '../../../extensions/context_extensions.dart';
import '../../../constants/design_constants.dart';
import '../state/home_view_model.dart';

class HomeComponentCardFilterSettings extends StatelessWidget {
  const HomeComponentCardFilterSettings({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final HomeViewModel viewModel;

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
              localizations?.pageHomeComponentSettingsFilterHeading ?? '',
              textAlign: TextAlign.start,
              style: context.textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              localizations?.pageHomeComponentSettingsFilterSubheading ?? '',
              textAlign: TextAlign.start,
              style: context.textTheme.caption,
            ),
            const Divider(color: Colors.white),
            kSpacingSmall.asHeightWidget,
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    localizations?.pageHomeComponentSettingsFilterTooltipsTimezone ?? '',
                    style: context.textTheme.bodyText2,
                  ),
                ),
                kSpacingMedium.asWidthWidget,
                DropdownButton<PocketArkTimezone>(
                  value: viewModel.systemService.timezone,
                  style: context.textTheme.caption,
                  onChanged: (PocketArkTimezone? timezone) => viewModel.systemService.updateTimezone(timezone ?? viewModel.systemService.timezone),
                  items: <DropdownMenuItem<PocketArkTimezone>>[
                    for (final PocketArkTimezone timezone in PocketArkTimezone.values) ...<DropdownMenuItem<PocketArkTimezone>>[
                      DropdownMenuItem(
                        child: Text(timezone.toLocale(context)),
                        value: timezone,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
