import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'application_service.dart';

Future<void> configurePocketArkServices() async {
  await inqvine.registerInqvineServices();

  // Core Services
  inqvine.registerService(ApplicationService());

  // Third Party Services
}
