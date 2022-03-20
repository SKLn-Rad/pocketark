// Flutter imports:
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

// Package imports:
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:inqvine_core_main/inqvine_core_main.dart';

// Project imports:
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
    appId: '1:26568019563:android:b3ed591b80e37e8ad5eb2e',
    messagingSenderId: '26568019563',
    projectId: 'pocketark-development',
    storageBucket: 'pocketark-development.appspot.com',
  );

  static const FirebaseOptions iosDevelopment = FirebaseOptions(
    apiKey: 'AIzaSyCwDgvloiYJbLU33KA6kzsfn3_5FtB2TC4',
    appId: '1:26568019563:ios:122ded1ab3948ffcd5eb2e',
    messagingSenderId: '26568019563',
    projectId: 'pocketark-development',
    storageBucket: 'pocketark-development.appspot.com',
    iosClientId: '26568019563-kv8ohkr0hmpvltof2p6k2o2pa3jidb3d.apps.googleusercontent.com',
    iosBundleId: 'com.inqvine.pocketark',
  );

  static const FirebaseOptions androidProduction = FirebaseOptions(
    apiKey: 'AIzaSyCFKVsn_kuFm78PKG-vXJoIpoUufDwFLlk',
    appId: '1:237512204819:android:46d6325b0369b00d1ed5e6',
    messagingSenderId: '237512204819',
    projectId: 'pocketark-production',
    storageBucket: 'pocketark-production.appspot.com',
  );

  static const FirebaseOptions iosProduction = FirebaseOptions(
    apiKey: 'AIzaSyC4t0Szk1aXbKLvFxYgi-Ya0sLjyQXBHPI',
    appId: '1:237512204819:ios:25053bdf78d221c01ed5e6',
    messagingSenderId: '237512204819',
    projectId: 'pocketark-production',
    storageBucket: 'pocketark-production.appspot.com',
    iosClientId: '237512204819-343id80q441gqc2r62cd0oq2ldmkfslj.apps.googleusercontent.com',
    iosBundleId: 'com.inqvine.pocketark',
  );
}
