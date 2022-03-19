// Flutter imports:
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Package imports:
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/resources/resources.dart';

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
    final SplashViewModel viewModel = useViewModel(ref, () => SplashViewModel());
    return PocketArkScaffold(
      body: Padding(
        padding: kSpacingLarge.asPaddingAll,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (viewModel.canRetryBootstrap) ...<Widget>[
                SvgPicture.asset(
                  PocketArkImages.logoLetter,
                  color: Colors.white,
                  height: kDecorationIconCenterHeight,
                ),
                kSpacingLarge.asHeightWidget,
                Text(
                  context.localizations?.errorsNotConnected ?? '',
                  style: context.textTheme.headline6,
                ),
                kSpacingSmall.asHeightWidget,
                CupertinoButton(
                  onPressed: viewModel.bootstrap,
                  color: context.theme.primaryColor,
                  child: Text(context.localizations?.sharedActionsRetry ?? ''),
                ),
              ],
              if (!viewModel.canRetryBootstrap) ...<Widget>[
                const PocketArkLoadingIndicator(),
                kSpacingMedium.asHeightWidget,
                Text(context.localizations?.pageSplashCaption ?? ''),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
