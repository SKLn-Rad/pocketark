import 'package:inqvine_core_firebase/inqvine_core_firebase.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/services/event_service.dart';

class EventAdminService extends InqvineServiceBase {
  Future<void> uploadNewEvents() async {
    final FirebaseAuth firebaseAuth = inqvine.getFromLocator();
    if (firebaseAuth.currentUser == null) {
      await firebaseAuth.signInWithEmailAndPassword(email: '', password: '');
    }

    // Get event data

    // Normalise event data

    // Clear existing collection
    'Deleting old events'.logDebug();
    final QuerySnapshot existingSnapshot = await EventService.kEventCollection.get();
    for (final DocumentSnapshot existingDocumentSnapshot in existingSnapshot.docs) {
      await existingDocumentSnapshot.reference.delete();
    }

    // Add new events
  }
}
