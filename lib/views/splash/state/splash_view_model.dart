import 'package:inqvine_core_main/inqvine_core_main.dart';
import '../../../constants/application_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../services/service_configuration.dart';

class SplashViewModel extends BaseViewModel with PocketArkServiceMixin {
  @override
  void onFirstRender() {
    super.onFirstRender();
    bootstrap();
  }

  Future<void> bootstrap() async {
    // Give enough time for page to not blink
    await Future<void>.delayed(const Duration(seconds: 1));

    // Check terms of use
    final bool? result = sharedPreferences.getBool(kSharedKeyTermsAccepted);
    if (result == null || !result) {
      kRouter.go('/terms');
    }
  }
}
