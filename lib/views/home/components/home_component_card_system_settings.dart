import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../extensions/context_extensions.dart';
import '../../../constants/design_constants.dart';
import '../state/home_view_model.dart';

class HomeComponentCardSystemSettings extends StatelessWidget {
  const HomeComponentCardSystemSettings({
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
              localizations?.pageHomeComponentSettingsSystemHeading ?? '',
              textAlign: TextAlign.start,
              style: context.textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              localizations?.pageHomeComponentSettingsSystemSubheading ?? '',
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
                  localizations?.pageHomeComponentSettingsButtonResetCache ?? '',
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
