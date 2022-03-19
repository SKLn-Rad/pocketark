import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/views/splash/state/splash_view_model.dart';

class SplashView extends HookConsumerWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useViewModel(ref, () => SplashViewModel());
    return const Scaffold(
      backgroundColor: Colors.pink,
    );
  }
}
