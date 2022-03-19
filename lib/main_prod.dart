import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import 'services/application_service.dart';
import 'services/service_configuration.dart';
import 'views/app.dart';

Future<void> main() async {
  inqvine.registerInLocator(ApplicationEnvironment.development);
  await configurePocketArkServices();
  runApp(const App());
}
