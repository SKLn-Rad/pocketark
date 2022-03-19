// ignore_for_file: lines_longer_than_80_chars
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/services/application_service.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }

    ApplicationEnvironment environment = ApplicationEnvironment.development;
    if (inqvine.isRegisteredInLocator<ApplicationEnvironment>()) {
      environment = inqvine.getFromLocator();
      'Setting up environment: $environment'.logInfo();
    }

    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return environment == ApplicationEnvironment.development ? androidDevelopment : androidProduction;
      case TargetPlatform.iOS:
        return environment == ApplicationEnvironment.development ? iosDevelopment : iosProduction;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions androidDevelopment = FirebaseOptions(
    apiKey: 'AIzaSyCwDgvloiYJbLU33KA6kzsfn3_5FtB2TC4',
    googleAppID: '1:26568019563:android:b3ed591b80e37e8ad5eb2e',
    gcmSenderID: '26568019563',
    projectID: 'pocketark-development',
    storageBucket: 'pocketark-development.appspot.com',
  );

  static const FirebaseOptions iosDevelopment = FirebaseOptions(
    apiKey: 'AIzaSyCwDgvloiYJbLU33KA6kzsfn3_5FtB2TC4',
    googleAppID: '1:26568019563:android:b3ed591b80e37e8ad5eb2e',
    gcmSenderID: '26568019563',
    projectID: 'pocketark-development',
    storageBucket: 'pocketark-development.appspot.com',
    clientID: '26568019563-kv8ohkr0hmpvltof2p6k2o2pa3jidb3d.apps.googleusercontent.com',
    bundleID: 'com.inqvine.pocketark',
  );

  static const FirebaseOptions androidProduction = FirebaseOptions(
    apiKey: 'AIzaSyCFKVsn_kuFm78PKG-vXJoIpoUufDwFLlk',
    googleAppID: '1:237512204819:android:46d6325b0369b00d1ed5e6',
    gcmSenderID: '237512204819',
    projectID: 'pocketark-production',
    storageBucket: 'pocketark-production.appspot.com',
  );

  static const FirebaseOptions iosProduction = FirebaseOptions(
    apiKey: 'AIzaSyC4t0Szk1aXbKLvFxYgi-Ya0sLjyQXBHPI',
    googleAppID: '1:237512204819:ios:25053bdf78d221c01ed5e6',
    gcmSenderID: '237512204819',
    projectID: 'pocketark-production',
    storageBucket: 'pocketark-production.appspot.com',
    clientID: '237512204819-343id80q441gqc2r62cd0oq2ldmkfslj.apps.googleusercontent.com',
    bundleID: 'com.inqvine.pocketark',
  );
}
