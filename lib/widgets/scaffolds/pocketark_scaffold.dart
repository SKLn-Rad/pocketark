// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/constants/design_constants.dart';
import 'package:pocketark/widgets/indicators/pocketark_loading_indicator.dart';

import 'pocketark_drawer.dart';

class PocketArkScaffold extends StatelessWidget {
  const PocketArkScaffold({
    required this.body,
    this.appBar,
    this.systemUiOverlayStyle,
    this.bottomNavigationBar,
    this.includeDrawer = true,
    this.isBusy = false,
    Key? key,
  }) : super(key: key);

  final SystemUiOverlayStyle? systemUiOverlayStyle;

  final BottomNavigationBar? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool includeDrawer;
  final bool isBusy;

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
          body: Stack(
            children: <Widget>[
              Positioned.fill(child: body),
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: kBasicAnimationDuration,
                  opacity: isBusy ? kEnabledOpacity : kInvisibleOpacity,
                  child: IgnorePointer(
                    ignoring: !isBusy,
                    child: Container(
                      color: kGrayDark.withOpacity(kDisabledOpacity),
                      child: const Center(
                        child: PocketArkLoadingIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: bottomNavigationBar,
          drawer: includeDrawer ? const PocketArkDrawer() : null,
        ),
      ),
    );
  }
}
