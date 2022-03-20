// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/constants/application_constants.dart';
import 'package:pocketark/services/service_configuration.dart';
import 'package:quiver/collection.dart';

// Project imports:
import 'package:pocketark/proto/events.pb.dart';
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
