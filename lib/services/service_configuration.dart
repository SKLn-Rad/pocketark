// Flutter imports:
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import '../constants/application_constants.dart';
import '../services/auth_service.dart';
import '../services/event_admin_service.dart';
import '../services/event_service.dart';
import '../services/system_service.dart';
import '../firebase_options.dart';
import 'application_service.dart';

Future<void> configurePocketArkServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inqvine.registerInqvineServices();

  // Third Party Services
  final FirebaseOptions firebaseOptions = DefaultFirebaseOptions.currentPlatform;
  final FirebaseApp firebaseApp = await Firebase.initializeApp(
    options: firebaseOptions,
  );

  inqvine.registerInLocator<FirebaseApp>(firebaseApp);
  inqvine.registerInLocator<FirebaseFirestore>(FirebaseFirestore.instance);
  inqvine.registerInLocator<FirebaseAuth>(FirebaseAuth.instance);
  inqvine.registerInLocator<Cron>(Cron());

  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  inqvine.registerInLocator(sharedPreferences);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(kNotificationsAndroidIcon);
  const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  inqvine.registerInLocator(flutterLocalNotificationsPlugin);

  final MobileAds mobileAds = MobileAds.instance;
  inqvine.registerInLocator(mobileAds);

  // Needed for schedule pushes
  tz.initializeTimeZones();

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
  MobileAds get mobileAds => inqvine.getFromLocator();
  SharedPreferences get sharedPreferences => inqvine.getFromLocator();
  FlutterLocalNotificationsPlugin get localNotifications => inqvine.getFromLocator();
  Cron get cron => inqvine.getFromLocator();
}

void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {}

void onSelectNotification(String? payload) {}
