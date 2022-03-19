import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../services/service_configuration.dart';

class SplashViewModel extends BaseViewModel with PocketArkServiceMixin {
  @override
  void onFirstRender() {
    super.onFirstRender();
    eventAdminService.uploadNewEvents();
  }
}
