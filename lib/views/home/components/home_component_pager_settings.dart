import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/constants/design_constants.dart';

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
      ],
    );
  }
}
