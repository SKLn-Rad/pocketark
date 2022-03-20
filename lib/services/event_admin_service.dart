// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

// Project imports:
import 'package:pocketark/services/event_service.dart';
import '../proto/events.pb.dart';

class EventAdminService extends InqvineServiceBase {
  final Map<String, dynamic> cachedJsonData = <String, dynamic>{};
  final Map<String, dynamic> cachedJsonMetadata = <String, dynamic>{};

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
    ].reduce((a, b) => a.difference(currentTime).abs() < b.difference(currentTime).abs() ? a : b).toUtc();

    if (isRange) {
      endTime = <DateTime>[
        DateTime.parse('${year - 1}-$eventMonth-${eventDay}T$endTimeHour:$endTimeMinute:00+01:00'),
        DateTime.parse('$year-$eventMonth-${eventDay}T$endTimeHour:$endTimeMinute:00+01:00'),
        DateTime.parse('${year + 1}-$eventMonth-${eventDay}T$endTimeHour:$endTimeMinute:00+01:00'),
      ].reduce((a, b) => a.difference(currentTime).abs() < b.difference(currentTime).abs() ? a : b).toUtc();
    }

    event.id = eventId;
    event.type = eventType;
    event.recItemLevel = eventItemLevel;

    // Attempt to find fallback name and icon path
    if (cachedJsonMetadata.containsKey(eventId.toString())) {
      event.fallbackName = cachedJsonMetadata[eventId.toString()][0];
      event.iconPath = cachedJsonMetadata[eventId.toString()][1];
    }

    final LostArkEvent_LostArkEventSchedule schedule = LostArkEvent_LostArkEventSchedule.create();
    schedule.timeStart = Int64(startTime.millisecondsSinceEpoch);
    if (isRange) {
      schedule.timeEnd = Int64(endTime!.millisecondsSinceEpoch);
    }

    //* Temporary hack to increment times by ten minutes (Check when new data)
    final bool shouldBumpTenMinutes = (7000 <= eventId && eventId < 8000 && ![7013, 7035].contains(eventId)) || [1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 5002, 5003, 5004, 6007, 6008, 6009, 6010, 6011].contains(eventId);
    if (shouldBumpTenMinutes) {
      schedule.timeStart = schedule.timeStart + (1000 * 60 * 10);
      if (isRange) {
        schedule.timeEnd = schedule.timeEnd + (1000 * 60 * 10);
      }
    }

    event.schedule.add(schedule);
    knownAdminEvents[eventId] = event;
  }

  Future<void> uploadNewEvents() async {
    final FirebaseAuth firebaseAuth = inqvine.getFromLocator();
    if (firebaseAuth.currentUser == null) {
      await firebaseAuth.signInWithEmailAndPassword(email: 'test@inqvine.com', password: '123456');
    }

    // Clear existing collection
    'Deleting old events'.logDebug();
    final QuerySnapshot existingSnapshot = await EventService.kEventCollection.get();
    for (final DocumentSnapshot existingDocumentSnapshot in existingSnapshot.docs) {
      await existingDocumentSnapshot.reference.delete();
    }

    // Get event data
    final String dataResponse = await rootBundle.loadString("assets/data.json");
    final String eventResponse = await rootBundle.loadString("assets/events.json");

    cachedJsonData.clear();
    cachedJsonMetadata.clear();
    cachedJsonData.addAll(json.decode(dataResponse));
    cachedJsonMetadata.addAll(json.decode(eventResponse));

    eventParseCache.clear();
    eventParseResults.clear();
    visitEventData(cachedJsonData);

    // Normalise event data
    knownAdminEvents.clear();
    for (final List<dynamic> data in eventParseResults) {
      updateEvent(data);
    }

    'Sorted data successfully'.logDebug();

    //* event[eventID]
    //? keyCatagory

    // Add new events
    for (final LostArkEvent event in knownAdminEvents.values) {
      final Object? json = event.toProto3Json();
      await EventService.kEventCollection.add(json);
    }
  }
}
