// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:inqvine_core_main/inqvine_core_main.dart';

// Project imports:
import '../../../constants/design_constants.dart';
import '../../../views/splash/state/splash_view_model.dart';
import '../../../extensions/context_extensions.dart';
import '../../../widgets/indicators/pocketark_loading_indicator.dart';
import '../../../widgets/scaffolds/pocketark_scaffold.dart';

class SplashView extends HookConsumerWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useViewModel(ref, () => SplashViewModel());
    return PocketArkScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const PocketArkLoadingIndicator(),
            kSpacingMedium.asHeightWidget,
            Text(context.localizations?.pageSplashCaption ?? ''),
          ],
        ),
      ),
    );
  }
}
