// Package imports:
import 'package:inqvine_core_main/inqvine_core_main.dart';

// Project imports:
import '../../../constants/application_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../services/service_configuration.dart';

class SplashViewModel extends BaseViewModel with PocketArkServiceMixin {
  bool _canRetryBootstrap = false;
  bool get canRetryBootstrap => _canRetryBootstrap;
  set canRetryBootstrap(bool val) {
    _canRetryBootstrap = val;
    notifyListeners();
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    bootstrap();
  }

  void handleError(dynamic error) {
    // Error assumed to be failed to login
    canRetryBootstrap = true;
  }

  Future<void> bootstrap() => handleAction(
        () async {
          // Give enough time for page to not blink
          canRetryBootstrap = false;
          await Future<void>.delayed(const Duration(seconds: 1));

          // Attempt anonymous login
          await authService.attemptAnonymousLogin();

          // Check terms of use
          final bool? result = sharedPreferences.getBool(kSharedKeyTermsAccepted);
          if (result == null || !result) {
            kRouter.go(kRoutePathTerms);
            return;
          }

          kRouter.go(kRoutePathEvents);
        },
        onError: handleError,
      );
}
