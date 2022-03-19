import 'package:firebase_auth/firebase_auth.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

class AuthService extends InqvineServiceBase {
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
}
