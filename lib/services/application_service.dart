import 'package:inqvine_core_main/inqvine_core_main.dart';

enum ApplicationEnvironment {
  development,
  production,
}

class ApplicationService extends InqvineServiceBase {
  // Set this prior to the service being created to set the environment
  // Example: `inqvine.registerInLocator(ApplicationEnvironment.development);` in [main_dev.dart]
  ApplicationEnvironment get environment {
    if (inqvine.isRegisteredInLocator<ApplicationEnvironment>()) {
      return inqvine.getFromLocator();
    }

    return ApplicationEnvironment.development;
  }
}
