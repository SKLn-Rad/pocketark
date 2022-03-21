import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/constants/application_constants.dart';
import 'package:pocketark/services/system_service.dart';

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
                  ListTile(
                    title: Text(context.localizations?.pageBurgerMenuSectionGame ?? ''),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Ionicons.calendar_outline),
                    title: Text(context.localizations?.pageBurgerMenuLabelEvents ?? ''),
                    onTap: () => kRouter.go(kRoutePathEvents),
                  ),
                  // ListTile(
                  //   dense: true,
                  //   leading: const Icon(Ionicons.timer_outline),
                  //   title: Text(context.localizations?.pageBurgerMenuLabelResets ?? ''),
                  //   onTap: () {},
                  // ),
                  ListTile(
                    title: Text(context.localizations?.pageBurgerMenuSectionCommunity ?? ''),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Ionicons.bug_outline),
                    title: Text(context.localizations?.pageBurgerMenuLabelReportIssue ?? ''),
                    onTap: () => inqvine.getFromLocator<SystemService>().openUrl(kUrlGithubIssues),
                  ),
                  // ListTile(
                  //   dense: true,
                  //   leading: const Icon(Ionicons.logo_discord),
                  //   title: Text(context.localizations?.pageBurgerMenuLabelJoinDiscord ?? ''),
                  //   onTap: () {},
                  // ),
                  ListTile(
                    title: Text(context.localizations?.pageBurgerMenuSectionSystem ?? ''),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Ionicons.document_outline),
                    title: Text(context.localizations?.pageBurgerMenuLabelLegal ?? ''),
                    onTap: () => kRouter.go(kRoutePathTerms),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Ionicons.code_outline),
                    title: Text(context.localizations?.pageBurgerMenuLabelLicenses ?? ''),
                    onTap: () => showLicensePage(context: context, applicationName: kApplicationName),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Ionicons.settings_outline),
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
