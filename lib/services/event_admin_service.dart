import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/proto/events.pb.dart';
import 'package:pocketark/services/event_service.dart';
import 'dart:convert';

class EventAdminService extends InqvineServiceBase {
  Future<void> uploadNewEvents() async {
    final FirebaseAuth firebaseAuth = inqvine.getFromLocator();
    if (firebaseAuth.currentUser == null) {
      await firebaseAuth.signInWithEmailAndPassword(email: 'test@inqvine.com', password: '123456');
    }

    // Get event data
    final String response = await rootBundle.loadString("assets/data.json");
    final Map<String, dynamic> rawData = json.decode(response);
    print(rawData);

    // Normalise event data
    final List<LostArkEvent> events = <LostArkEvent>[];

    // Clear existing collection
    'Deleting old events'.logDebug();
    final QuerySnapshot existingSnapshot = await EventService.kEventCollection.get();
    for (final DocumentSnapshot existingDocumentSnapshot in existingSnapshot.docs) {
      await existingDocumentSnapshot.reference.delete();
    }

    // Add new events
    for (final LostArkEvent event in events) {
      final Object? json = event.toProto3Json();
      await EventService.kEventCollection.add(json);
    }
  }
}
