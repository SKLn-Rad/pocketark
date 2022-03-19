// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

// Project imports:
import '../firebase_options.dart';
import 'application_service.dart';

Future<void> configurePocketArkServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inqvine.registerInqvineServices();

  // Core Services
  await inqvine.registerService(ApplicationService());

  // Third Party Services
  final FirebaseApp firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  inqvine.registerInLocator<FirebaseApp>(firebaseApp);
}

mixin PocketArkServiceMixin {
  // Core Services
  ApplicationService get applicationService => inqvine.getFromLocator();

  // Third Party Services
  FirebaseApp get firebaseApp => inqvine.getFromLocator();
}
