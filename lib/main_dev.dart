// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:inqvine_core_main/inqvine_core_main.dart';

// Project imports:
import 'services/application_service.dart';
import 'services/service_configuration.dart';
import 'views/app.dart';

Future<void> main() async {
  inqvine.registerInLocator(ApplicationEnvironment.development);
  await configurePocketArkServices();
  runApp(const App());
}
