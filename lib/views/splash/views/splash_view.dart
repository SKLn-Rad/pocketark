import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/views/splash/state/splash_view_model.dart';

import '../../../widgets/scaffolds/pocketark_scaffold.dart';
import '../../../extensions/context_extensions.dart';

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
            const SpinKitSpinningCircle(color: Colors.white),
            const SizedBox(height: 10.0),
            Text(context.localizations?.pageSplashCaption ?? ''),
          ],
        ),
      ),
    );
  }
}
