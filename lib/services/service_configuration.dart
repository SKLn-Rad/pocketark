// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:pocketark/services/event_admin_service.dart';
import 'package:pocketark/services/event_service.dart';
import 'package:pocketark/services/system_service.dart';
import '../firebase_options.dart';
import 'application_service.dart';

Future<void> configurePocketArkServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inqvine.registerInqvineServices();

  // Third Party Services
  final FirebaseApp firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  inqvine.registerInLocator<FirebaseApp>(firebaseApp);
  inqvine.registerInLocator<FirebaseFirestore>(FirebaseFirestore.instance);
  inqvine.registerInLocator<FirebaseAuth>(FirebaseAuth.instance);

  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  inqvine.registerInLocator(sharedPreferences);

  // Core Services
  await inqvine.registerService(ApplicationService());
  await inqvine.registerService(EventService());
  await inqvine.registerService(EventAdminService());
  await inqvine.registerService(SystemService());
  await inqvine.registerService(AuthService());
}

mixin PocketArkServiceMixin {
  // Core Services
  ApplicationService get applicationService => inqvine.getFromLocator();
  EventService get eventService => inqvine.getFromLocator();
  EventAdminService get eventAdminService => inqvine.getFromLocator();
  SystemService get systemService => inqvine.getFromLocator();
  AuthService get authService => inqvine.getFromLocator();

  // Third Party Services
  FirebaseApp get firebaseApp => inqvine.getFromLocator();
  FirebaseFirestore get firebaseFirestore => inqvine.getFromLocator();
  FirebaseAuth get firebaseAuth => inqvine.getFromLocator();
  SharedPreferences get sharedPreferences => inqvine.getFromLocator();
}
