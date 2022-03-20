// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/constants/route_constants.dart';
import 'package:quiver/collection.dart';
import 'package:timezone/timezone.dart' as tz;

// Project imports:
import '../constants/application_constants.dart';
import '../services/service_configuration.dart';
import '../extensions/event_extensions.dart';
import '../proto/events.pb.dart';
import '../events/events_updated_event.dart';

class EventService extends InqvineServiceBase with PocketArkServiceMixin {
  static const String kEventCollectionName = 'events';
  static CollectionReference get kEventCollection => inqvine.getFromLocator<FirebaseFirestore>().collection(EventService.kEventCollectionName);

  StreamSubscription<User?>? userSubscription;
  StreamSubscription<QuerySnapshot<Object?>>? eventsSubscription;

  //* All events detected
  final BiMap<QueryDocumentSnapshot, LostArkEvent> events = BiMap();

  @override
  Future<void> initializeService() async {
    prepareUserListeners();
    return super.initializeService();
  }

  Future<void> prepareUserListeners() async {
    if (!inqvine.isRegisteredInLocator<FirebaseAuth>()) {
      return;
    }

    final FirebaseAuth auth = inqvine.getFromLocator();
    await userSubscription?.cancel();
    userSubscription = auth.authStateChanges().listen(onUserChanged);
  }

  Future<void> onUserChanged(User? user) async {
    'Detected user change from $runtimeType'.logInfo();
    await eventsSubscription?.cancel();
    events.clear();
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: true));

    if (user == null) {
      return;
    }

    'Listening for new events'.logDebug();
    eventsSubscription = kEventCollection.snapshots().listen(onEventsChanged);
  }

  void onEventsChanged(QuerySnapshot<Object?> eventQuerySnapshot) {
    'Detected events changed'.logInfo();
    events.clear();

    for (final QueryDocumentSnapshot<Object?> eventSnapshot in eventQuerySnapshot.docs) {
      final LostArkEvent event = LostArkEvent.create()..mergeFromProto3Json(eventSnapshot.data(), ignoreUnknownFields: true);
      events.putIfAbsent(eventSnapshot, () => event);
    }

    'Found ${events.length} new events'.logInfo();
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: true));
    unawaited(scheduleNotifications());
  }

  Future<void> scheduleNotifications() async {
    // Unschedule all notifications
    await localNotifications.cancelAll();

    // Loop and check if muted
    int notificationId = 0;
    for (final LostArkEvent event in events.values) {
      if (isEventMuted(event)) {
        return;
      }

      for (final LostArkEvent_LostArkEventSchedule schedule in event.schedule) {
        final tz.TZDateTime scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.UTC, schedule.timeStart.toInt()).subtract(const Duration(minutes: 15));
        final tz.TZDateTime currentTime = tz.TZDateTime.now(tz.UTC);

        //* Do not schedule in the past (Add one second for logic completion)
        if (currentTime.millisecondsSinceEpoch > scheduleTime.millisecondsSinceEpoch - 1000) {
          continue;
        }

        //* Do not schedule too far into the future (6 hours)
        if (currentTime.millisecondsSinceEpoch + (1000 * 60 * 60 * 12) > scheduleTime.millisecondsSinceEpoch) {
          continue;
        }

        await localNotifications.zonedSchedule(
          notificationId,
          event.eventNameWithItemLevel,
          'Event is starting in 15 minutes',
          scheduleTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(kApplicationName, kApplicationName),
            iOS: IOSNotificationDetails(threadIdentifier: kApplicationName),
          ),
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );

        notificationId++;

        //* Break if too many notifications are schedules
        if (notificationId > 400) {
          break;
        }
      }
    }

    'Scheduled notifications successfully'.logDebug();
  }

  bool isEventMuted(LostArkEvent event) {
    final String sharedKey = '$kSharedKeyMutedEvent${event.id}';
    return sharedPreferences.containsKey(sharedKey) && sharedPreferences.getBool(sharedKey) == true;
  }

  Future<void> unmuteAllEvents() async {
    for (final LostArkEvent event in events.values) {
      await unmuteEvent(event);
    }
  }

  Future<void> muteAllEvents() async {
    for (final LostArkEvent event in events.values) {
      await muteEvent(event);
    }
  }

  Future<void> unmuteEvent(LostArkEvent event) async {
    'Unmuting event: ${event.fallbackName}'.logInfo();
    final String sharedKey = '$kSharedKeyMutedEvent${event.id}';
    await sharedPreferences.setBool(sharedKey, false);
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: false));
  }

  Future<void> muteEvent(LostArkEvent event) async {
    'Muting event: ${event.fallbackName}'.logInfo();
    final String sharedKey = '$kSharedKeyMutedEvent${event.id}';
    await sharedPreferences.setBool(sharedKey, true);
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: false));
  }
}
