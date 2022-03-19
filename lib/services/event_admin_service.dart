import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/proto/events.pb.dart';
import 'package:pocketark/proto/events.pbjson.dart';
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

    rawData.forEach((k, v) => print("Key : $k, Value : $v"));

    // Normalise event data
    final Map<int, LostArkEvent> events = <int, LostArkEvent>{};

    // rawData.;

    //* event[eventID]
    //? keyCatagory
    for (final String keyCatagory in rawData.keys) {
      final Map<String, dynamic> monthData = rawData[keyCatagory];
      for (final String keyMonth in monthData.keys) {
        final Map<String, dynamic> dayData = monthData[keyMonth];
        for (final String keyDay in dayData.keys) {
          final Map<String, dynamic> itemLevelData = dayData[keyDay];
          for (final String keyItemLevel in itemLevelData.keys) {
            if (itemLevelData[keyItemLevel] is! Map<String, dynamic>) {
              // catch properly later
              continue;
            }
            final Map<String, dynamic> eventIDData = itemLevelData[keyItemLevel];
            for (final String keyEventID in eventIDData.keys) {
              final int? catagoryValue = int.tryParse(keyCatagory);
              final int? monthValue = int.tryParse(keyCatagory);
              final int? dayValue = int.tryParse(keyCatagory);
              final int? itemLevelValue = int.tryParse(keyCatagory);
              final int? eventValue = int.tryParse(keyCatagory);

              if (catagoryValue == null || monthValue == null || dayValue == null || itemLevelValue == null || eventValue == null) {
                continue;
              }

              LostArkEvent lostArkEvent = LostArkEvent.create();
              if (events.containsKey(eventValue)) {
                lostArkEvent = events[eventValue]!;
              }

              lostArkEvent.id = eventValue;
              lostArkEvent.recItemLevel = itemLevelValue;
              lostArkEvent.type = catagoryValue;

              final LostArkEvent_LostArkEventSchedule schedule = LostArkEvent_LostArkEventSchedule.create();
              schedule.day = dayValue;
              schedule.month = monthValue;
              // schedule.time = eventIDData[keyEventID] list;

              events[eventValue] = lostArkEvent;
            }
          }
        }
      }
    }

    // print(events);

    // Clear existing collection
    'Deleting old events'.logDebug();
    final QuerySnapshot existingSnapshot = await EventService.kEventCollection.get();
    for (final DocumentSnapshot existingDocumentSnapshot in existingSnapshot.docs) {
      await existingDocumentSnapshot.reference.delete();
    }

    // Add new events
    for (final LostArkEvent event in events.values) {
      final Object? json = event.toProto3Json();
      await EventService.kEventCollection.add(json);
    }
  }
}
