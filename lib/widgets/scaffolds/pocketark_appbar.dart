import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/design_constants.dart';
import '../../resources/resources.dart';

class PocketArkAppBar extends StatelessWidget with PreferredSizeWidget {
  const PocketArkAppBar({
    this.actions = const <Widget>[],
    Key? key,
  }) : super(key: key);

  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  static const String kHeroTag = 'heroes-appbar';

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: kHeroTag,
      child: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          PocketArkImages.logoLetter,
          height: kAppBarIconHeight,
        ),
        actions: actions,
      ),
    );
  }
}
