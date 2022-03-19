import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

class PocketArkScaffold extends StatelessWidget {
  const PocketArkScaffold({
    required this.body,
    this.systemUiOverlayStyle,
    Key? key,
  }) : super(key: key);

  final SystemUiOverlayStyle? systemUiOverlayStyle;

  final Widget body;

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
      systemNavigationBarColor: context.theme.scaffoldBackgroundColor,
      statusBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: actualStyle,
      child: GestureDetector(
        onTap: () => handleKeyboardDismiss(context),
        child: Scaffold(
          body: body,
        ),
      ),
    );
  }
}
