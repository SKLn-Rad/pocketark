import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../constants/application_constants.dart';
import '../../constants/design_constants.dart';

class PocketArkDrawerHeader extends StatelessWidget {
  const PocketArkDrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.0 + context.devicePadding.top,
      width: double.infinity,
      color: context.theme.primaryColor,
      padding: kSpacingLarge.asPaddingAll,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(kApplicationName, style: context.textTheme.subtitle2),
      ),
    );
  }
}
