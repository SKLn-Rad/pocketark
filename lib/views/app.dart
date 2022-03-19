// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

// Project imports:
import '../constants/application_constants.dart';
import '../extensions/context_extensions.dart';
import '../views/splash/views/splash_view.dart';

class App extends StatelessWidget {
  const App({
    this.child,
    Key? key,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        onGenerateTitle: (BuildContext context) => context.localizations?.applicationName ?? '',
        navigatorKey: kNavigatorKey,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child ?? const SplashView(),
      ),
    );
  }
}
