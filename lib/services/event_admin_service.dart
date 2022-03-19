import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/proto/events.pb.dart';
import 'dart:convert';

class EventAdminService extends InqvineServiceBase {
  final Map<int, LostArkEvent> knownAdminEvents = <int, LostArkEvent>{};
  final Set<Map<String, dynamic>> items = {};
  Map<int, dynamic> cache = <int, dynamic>{};

  void visitObject(object, {int depth = 0}) {
    if (object is List) {
      for (dynamic item in object) {
        cache[depth] = item;
        visitObject(item, depth: depth + 1);
      }
    } else if (object is Map) {
      for (dynamic item in object.keys) {
        cache[depth] = item;
        visitObject(object[item], depth: depth + 1);
      }
    } else if (object is String) {
      print('Object $object found at depth $depth');
      // Walk back through depth, getting the correct values
    }
  }

  void updateEvent(int? catagoryValue, int? monthValue, int? dayValue, int itemLevelValue, int? eventValue, String timeValue) {
    if (catagoryValue == null || monthValue == null || dayValue == null || eventValue == null) {
      return;
    }

    LostArkEvent event = LostArkEvent.create();
    if (knownAdminEvents.containsKey(eventValue)) {
      event = knownAdminEvents[eventValue]!;
    }

    print('Making new schedule for event: $eventValue');
  }

  Future<void> uploadNewEvents() async {
    final FirebaseAuth firebaseAuth = inqvine.getFromLocator();
    if (firebaseAuth.currentUser == null) {
      await firebaseAuth.signInWithEmailAndPassword(email: 'test@inqvine.com', password: '123456');
    }

    // Clear existing collection
    // 'Deleting old events'.logDebug();
    // final QuerySnapshot existingSnapshot = await EventService.kEventCollection.get();
    // for (final DocumentSnapshot existingDocumentSnapshot in existingSnapshot.docs) {
    //   await existingDocumentSnapshot.reference.delete();
    // }

    // Get event data
    final String response = await rootBundle.loadString("assets/data.json");
    final Map<String, dynamic> rawData = json.decode(response);
    items.clear();
    visitObject(rawData);

    // Normalise event data
    knownAdminEvents.clear();

    //* event[eventID]
    //? keyCatagory

    // Add new events
    // for (final LostArkEvent event in knownAdminEvents.values) {
    //   final Object? json = event.toProto3Json();
    //   await EventService.kEventCollection.add(json);
    // }
  }
}
