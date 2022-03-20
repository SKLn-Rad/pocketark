import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:inqvine_core_ui/inqvine_core_ui.dart';

import '../../../constants/application_constants.dart';
import '../../../extensions/context_extensions.dart';
import '../../../constants/design_constants.dart';
import '../../../resources/resources.dart';
import '../../../views/home/state/home_view_model.dart';
import 'home_component_card_filter_settings.dart';
import 'home_component_card_system_settings.dart';

class HomeComponentPagerSettings extends StatelessWidget {
  const HomeComponentPagerSettings({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: kSpacingLarge.asPaddingAll,
      children: <Widget>[
        HomeComponentCardFilterSettings(viewModel: viewModel),
        kSpacingMedium.asHeightWidget,
        HomeComponentCardSystemSettings(viewModel: viewModel),
        kSpacingExtraLarge.asHeightWidget,
        InqvineTapHandler(
          isEnabled: !viewModel.isBusy,
          onTap: () => viewModel.systemService.openUrl(kUrlInqvine),
          child: Column(
            children: <Widget>[
              Center(
                child: SvgPicture.asset(
                  PocketArkImages.inqvine,
                  height: kAppBarIconHeight,
                ),
              ),
              kSpacingSmall.asHeightWidget,
              Text(
                context.localizations?.pageHomeComponentSettingsCreatorBody ?? '',
                textAlign: TextAlign.center,
                style: context.textTheme.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
