// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

// Project imports:
import '../constants/design_constants.dart';
import '../constants/route_constants.dart';
import '../extensions/context_extensions.dart';

class App extends StatelessWidget {
  const App({
    this.child,
    Key? key,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: _MaterialShim(),
    );
  }
}

class _MaterialShim extends StatelessWidget {
  const _MaterialShim({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: kRouter.routeInformationParser,
      routerDelegate: kRouter.routerDelegate,
      onGenerateTitle: (BuildContext context) => context.localizations?.applicationName ?? '',
      supportedLocales: AppLocalizations.supportedLocales,
      theme: kThemeData,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
