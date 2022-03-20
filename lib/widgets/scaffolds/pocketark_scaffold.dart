// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:inqvine_core_main/inqvine_core_main.dart';

import 'pocketark_drawer.dart';

class PocketArkScaffold extends StatelessWidget {
  const PocketArkScaffold({
    required this.body,
    this.appBar,
    this.systemUiOverlayStyle,
    this.bottomNavigationBar,
    this.includeDrawer = true,
    Key? key,
  }) : super(key: key);

  final SystemUiOverlayStyle? systemUiOverlayStyle;

  final BottomNavigationBar? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool includeDrawer;

  void handleKeyboardDismiss(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle? actualStyle = systemUiOverlayStyle;
    actualStyle ??= SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: context.theme.primaryColor,
      statusBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: actualStyle,
      child: GestureDetector(
        onTap: () => handleKeyboardDismiss(context),
        child: Scaffold(
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
          drawer: includeDrawer ? const PocketArkDrawer() : null,
        ),
      ),
    );
  }
}
