import 'package:firebase_auth/firebase_auth.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../services/service_configuration.dart';

class SplashViewModel extends BaseViewModel with PocketArkServiceMixin {
  @override
  void onFirstRender() {
    super.onFirstRender();
    attemptAnonymousLogin();
  }
}

Future<void> attemptAnonymousLogin() async {
  'Attempting to login anonymously'.logDebug();
  if (!inqvine.isRegisteredInLocator<FirebaseAuth>()) {
    return;
  }

  final FirebaseAuth firebaseAuth = inqvine.getFromLocator();
  if (firebaseAuth.currentUser != null) {
    'Already logged in'.logDebug();
    return;
  }

  await firebaseAuth.signInAnonymously();
  'Signed in successfully'.logInfo();
}
