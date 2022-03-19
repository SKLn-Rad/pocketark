import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import '../proto/events.pb.dart';

class EventAdminService extends InqvineServiceBase {
  final Map<int, LostArkEvent> knownAdminEvents = <int, LostArkEvent>{};

  final Map<int, dynamic> eventParseCache = <int, dynamic>{};
  final List<List<dynamic>> eventParseResults = <List<dynamic>>[];

  void visitEventData(object, {int depth = 0}) {
    eventParseCache.removeWhere((key, value) => key > depth);
    if (object is List) {
      for (dynamic item in object) {
        visitEventData(item, depth: depth + 1);
      }
    } else if (object is Map) {
      for (dynamic item in object.keys) {
        eventParseCache[depth] = item;
        visitEventData(object[item], depth: depth + 1);
      }
    } else if (object is String) {
      // Walk back through depth, getting the correct values
      eventParseCache[depth] = object;
      eventParseResults.add(eventParseCache.values.toList());
    }
  }

  void updateEvent(List<dynamic> data) {
    LostArkEvent event = LostArkEvent.create();

    // print('Making new schedule for event: $eventValue');
    final int? eventType = int.tryParse(data[0]);
    final String eventMonth = (data[1] as String).padLeft(2, '0');
    final String eventDay = (data[2]).padLeft(2, '0');
    final int eventItemLevel = int.tryParse(data[3]) ?? 0;
    final int? eventId = int.tryParse(data[4]);
    final String time = data[5];

    if (eventType == null || eventId == null) {
      return;
    }

    //* Get existing if it exists
    if (knownAdminEvents.containsKey(eventId)) {
      event = knownAdminEvents[eventId]!;
    }

    // Get start and end time
    final bool isRange = time.contains('-');
    String startTimeHour = '';
    String startTimeMinute = '';
    String endTimeHour = '';
    String endTimeMinute = '';

    if (isRange) {
      startTimeHour = time.split('-').first.split(':').first.padLeft(2, '0');
      startTimeMinute = time.split('-').first.split(':').last.padLeft(2, '0');
      endTimeHour = time.split('-').last.split(':').first.padLeft(2, '0');
      endTimeMinute = time.split('-').last.split(':').last.padLeft(2, '0');
    } else {
      startTimeHour = time.split(':').first.padLeft(2, '0');
      startTimeMinute = time.split(':').last.padLeft(2, '0');
    }

    // Get closest time
    DateTime? startTime;
    DateTime? endTime;

    final DateTime currentTime = DateTime.now().toUtc();
    final int year = currentTime.year;

    //* Hack to determine which year is most likely as we only get month and day
    startTime = <DateTime>[
      DateTime.parse('${year - 1}-$eventMonth-${eventDay}T$startTimeHour:$startTimeMinute:00+01:00'),
      DateTime.parse('$year-$eventMonth-${eventDay}T$startTimeHour:$startTimeMinute:00+01:00'),
      DateTime.parse('${year + 1}-$eventMonth-${eventDay}T$startTimeHour:$startTimeMinute:00+01:00'),
    ].reduce((a, b) => a.difference(currentTime).abs() < b.difference(currentTime).abs() ? a : b);

    if (isRange) {
      endTime = <DateTime>[
        DateTime.parse('${year - 1}-$eventMonth-${eventDay}T$endTimeHour:$endTimeMinute:00+01:00'),
        DateTime.parse('$year-$eventMonth-${eventDay}T$endTimeHour:$endTimeMinute:00+01:00'),
        DateTime.parse('${year + 1}-$eventMonth-${eventDay}T$endTimeHour:$endTimeMinute:00+01:00'),
      ].reduce((a, b) => a.difference(currentTime).abs() < b.difference(currentTime).abs() ? a : b);
    }

    'Got times: $startTime - $endTime'.logDebug();
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

    eventParseCache.clear();
    eventParseResults.clear();
    visitEventData(rawData);

    // Normalise event data
    knownAdminEvents.clear();
    for (final List<dynamic> data in eventParseResults) {
      updateEvent(data);
    }

    'Sorted data successfully'.logDebug();

    //* event[eventID]
    //? keyCatagory

    // Add new events
    // for (final LostArkEvent event in knownAdminEvents.values) {
    //   final Object? json = event.toProto3Json();
    //   await EventService.kEventCollection.add(json);
    // }
  }
}
