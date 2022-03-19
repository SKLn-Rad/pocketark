import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../constants/application_constants.dart';
import '../../../constants/design_constants.dart';
import '../state/home_view_model.dart';

class HomeComponentPagerHome extends StatelessWidget {
  const HomeComponentPagerHome({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Coming soon!',
          style: context.textTheme.headline6,
        ),
        GestureDetector(
          onTap: () => viewModel.systemService.openUrl(kUrlGithub),
          child: Text(
            'Check out our GitHub for more details',
            style: context.textTheme.caption!.copyWith(
              color: kHighlightColor,
            ),
          ),
        ),
      ],
    );
  }
}
