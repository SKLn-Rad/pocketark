import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../constants/design_constants.dart';
import '../../constants/route_constants.dart';
import '../../extensions/context_extensions.dart';
import 'pocketark_drawer_header.dart';

class PocketArkDrawer extends StatelessWidget {
  const PocketArkDrawer({
    this.index = -1,
    Key? key,
  }) : super(key: key);

  final int index;

  static const String kHeroTagDrawer = 'hero-drawer';

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: kHeroTagDrawer,
      child: Drawer(
        child: Column(
          children: <Widget>[
            const PocketArkDrawerHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  kSpacingMedium.asHeightWidget,
                  ListTile(
                    dense: true,
                    leading: const CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      child: Icon(Ionicons.calendar_outline),
                    ),
                    title: Text(context.localizations?.pageBurgerMenuLabelEvents ?? ''),
                    onTap: () => kRouter.go(kRoutePathEvents),
                  ),
                  kSpacingMedium.asHeightWidget,
                  ListTile(
                    dense: true,
                    leading: const CircleAvatar(
                      backgroundColor: kTertiaryColor,
                      foregroundColor: Colors.white,
                      child: Icon(Ionicons.settings_outline),
                    ),
                    title: Text(context.localizations?.pageBurgerMenuLabelSettings ?? ''),
                    onTap: () => kRouter.go(kRoutePathSettings),
                  ),
                  kSpacingMedium.asHeightWidget,
                  context.devicePadding.bottom.asHeightWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
