// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/constants/route_constants.dart';
import 'package:quiver/collection.dart';
import 'package:timezone/timezone.dart' as tz;

// Project imports:
import '../extensions/context_extensions.dart';
import '../constants/application_constants.dart';
import '../services/service_configuration.dart';
import '../extensions/event_extensions.dart';
import '../proto/events.pb.dart';
import '../events/events_updated_event.dart';

class EventService extends InqvineServiceBase with PocketArkServiceMixin {
  static const String kEventCollectionName = 'events';
  static CollectionReference get kEventCollection => inqvine.getFromLocator<FirebaseFirestore>().collection(EventService.kEventCollectionName);

  ScheduledTask? notificationScheduleTask;
  StreamSubscription<User?>? userSubscription;
  StreamSubscription<QuerySnapshot<Object?>>? eventsSubscription;

  //* All events detected
  final BiMap<QueryDocumentSnapshot, LostArkEvent> events = BiMap();

  @override
  Future<void> initializeService() async {
    prepareUserListeners();
    prepareCronTabs();
    return super.initializeService();
  }

  Future<void> prepareCronTabs() async {
    final Schedule notificationSchedule = Schedule.parse('1 * * * *');
    await notificationScheduleTask?.cancel();
    notificationScheduleTask = cron.schedule(notificationSchedule, scheduleNotifications);
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

    'Found ${events.length} new eventSchedules'.logInfo();
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: true));
    unawaited(scheduleNotifications());
  }

  Future<void> scheduleNotifications() async {
    // Unschedule all notifications
    //* should this be the case? or should we keep track of notifications and only update the ones needed?
    await localNotifications.cancelAll();
    await cleanupAlarms();

    // Get and check context
    final BuildContext? context = kRouter.routerDelegate.navigatorKey.currentState?.context;
    if (context == null) {
      return;
    }

    final AppLocalizations? localizations = context.localizations;
    if (localizations == null) {
      return;
    }

    final bool notificationsEnabled = sharedPreferences.getBool(kSharedKeyNotificationEnabledFlag) ?? true;
    if (!notificationsEnabled) {
      'Cannot schedule new notifications as disabled'.logInfo();
      return;
    }

    // Loop and check if muted
    int notificationId = 0;
    final int timeMinutesBeforeNotification = sharedPreferences.getInt(kSharedKeyNotificationPreTime) ?? 5;

    for (final LostArkEvent event in events.values) {
      final List<DateTime> eventAlarms = getAlarmsForEvent(event);
      final tz.TZDateTime currentTime = tz.TZDateTime.now(tz.UTC);

      for (DateTime time in eventAlarms) {
        if (time.millisecondsSinceEpoch <= 0) {
          continue;
        }
        final tz.TZDateTime scheduleTime = tz.TZDateTime.from(time, tz.UTC).subtract(Duration(minutes: timeMinutesBeforeNotification));

        //* Do not schedule in the past (Add one second for logic completion)
        if (currentTime.millisecondsSinceEpoch > scheduleTime.millisecondsSinceEpoch - 1000) {
          continue;
        }

        //* Do not schedule too far into the future (6 hours)
        //? Milliseconds * Seconds * Minutes * Hours (this is 1 hour?)
        if (currentTime.millisecondsSinceEpoch + (1000 * 60 * 60 * 1) < scheduleTime.millisecondsSinceEpoch) {
          continue;
        }

        await localNotifications.zonedSchedule(
          notificationId,
          event.eventNameWithItemLevel,
          localizations.eventNotificationDescription(timeMinutesBeforeNotification),
          scheduleTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(kApplicationName, kApplicationName),
            iOS: IOSNotificationDetails(threadIdentifier: kApplicationName),
          ),
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );

        //* Break if too many notifications are schedules
        notificationId++;
        if (notificationId > 400) {
          break;
        }
      }

      for (final LostArkEvent_LostArkEventSchedule schedule in event.schedule) {
        final tz.TZDateTime scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.UTC, schedule.timeStart.toInt()).subtract(Duration(minutes: timeMinutesBeforeNotification));

        //* Do not schedule in the past (Add one second for logic completion)
        if (currentTime.millisecondsSinceEpoch > scheduleTime.millisecondsSinceEpoch - 1000) {
          continue;
        }

        //* Do not schedule too far into the future (6 hours)
        //? Milliseconds * Seconds * Minutes * Hours (this is 1 hour?)
        if (currentTime.millisecondsSinceEpoch + (1000 * 60 * 60 * 1) < scheduleTime.millisecondsSinceEpoch) {
          continue;
        }

        await localNotifications.zonedSchedule(
          notificationId,
          event.eventNameWithItemLevel,
          localizations.eventNotificationDescription(timeMinutesBeforeNotification),
          scheduleTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(kApplicationName, kApplicationName),
            iOS: IOSNotificationDetails(threadIdentifier: kApplicationName),
          ),
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );

        //* Break if too many notifications are schedules
        notificationId++;
        if (notificationId > 400) {
          break;
        }
      }
    }

    'Scheduled notifications successfully'.logDebug();
  }

  bool isGlobalEventAlarmActive(LostArkEvent event) {
    final String sharedKey = '$kSharedKeyEventGlobalAlarm${event.id}';
    return sharedPreferences.containsKey(sharedKey) && sharedPreferences.getBool(sharedKey) == true;
  }

  Future<void> enableAllGlobalEventAlarms() async {
    for (final LostArkEvent event in events.values) {
      await enableGlobalEventAlarm(event);
    }

    await scheduleNotifications();
  }

  Future<void> disableAllGlobalEventAlarms() async {
    for (final LostArkEvent event in events.values) {
      await disableGlobalEventAlarm(event);
    }

    await scheduleNotifications();
  }

  Future<void> enableGlobalEventAlarm(LostArkEvent event, {bool shouldReschedule = false}) async {
    'enabling global alarm for event: ${event.fallbackName}'.logInfo();
    final String sharedKey = '$kSharedKeyEventGlobalAlarm${event.id}';

    //? set global event alarm to on (true)
    await sharedPreferences.setBool(sharedKey, true);
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: false));

    if (shouldReschedule) {
      await scheduleNotifications();
    }
  }

  Future<void> disableGlobalEventAlarm(LostArkEvent event, {bool shouldReschedule = false}) async {
    'disabling global alarm for event: ${event.fallbackName}'.logInfo();
    final String sharedKey = '$kSharedKeyEventGlobalAlarm${event.id}';

    //? set global event alarm to off (false)
    await sharedPreferences.setBool(sharedKey, false);
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: false));

    if (shouldReschedule) {
      await scheduleNotifications();
    }
  }

  Future<void> toggleEventGlobalAlarm(LostArkEvent event) async {
    'Toggling global alarm for event: ${event.fallbackName}'.logInfo();
    final bool isGlobalEventAlarmActive = eventService.isGlobalEventAlarmActive(event);

    if (isGlobalEventAlarmActive) {
      await disableGlobalEventAlarm(event, shouldReschedule: true);
    } else {
      await enableGlobalEventAlarm(event, shouldReschedule: true);
    }
  }

  bool isSingleAlarmActive(LostArkEvent event, LostArkEvent_LostArkEventSchedule schedule) {
    // 'Checking alarm for event: ${event.fallbackName} at ${DateTime.fromMillisecondsSinceEpoch(schedule.timeStart.toInt())}'.logDebug();
    final String alarmString = schedule.timeStart.toString();
    final String sharedKey = '$kSharedKeyEventAlarms${event.id}';

    final List<String> timeList = sharedPreferences.getStringList(sharedKey) ?? <String>[];

    //* Check if shared pref list contains the time already, otherwise add it
    if (timeList.contains(alarmString)) {
      return true;
    }
    return false;
  }

  Future<void> toggleAlarm(LostArkEvent event, LostArkEvent_LostArkEventSchedule schedule) async {
    if (isSingleAlarmActive(event, schedule)) {
      await removeAlarm(event, schedule);
    } else {
      await addAlarm(event, schedule);
    }
  }

  Future<void> addAlarm(LostArkEvent event, LostArkEvent_LostArkEventSchedule schedule, {bool shouldReschedule = false}) async {
    'Adding alarm for event: ${event.fallbackName} at ${schedule.timeStart}'.logInfo();

    final String alarmString = schedule.timeStart.toString();
    final String sharedKey = '$kSharedKeyEventAlarms${event.id}';

    final List<String> timeList = sharedPreferences.getStringList(sharedKey) ?? <String>[];

    //* Check if shared pref list contains the time already, otherwise add it
    if (!timeList.contains(alarmString)) {
      timeList.add(alarmString);
      await sharedPreferences.setStringList(sharedKey, timeList);
      inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: false));
    }

    if (shouldReschedule) {
      await scheduleNotifications();
    }
  }

  List<DateTime> getAlarmsForEvent(LostArkEvent event) {
    final String sharedKey = '$kSharedKeyEventAlarms${event.id}';

    final List<String> timeList = sharedPreferences.getStringList(sharedKey) ?? <String>[];
    final List<DateTime> dateTimeList = timeList.map((e) => DateTime.tryParse(e) ?? DateTime(0)).toList();
    return dateTimeList;
  }

  Future<void> removeAlarm(LostArkEvent event, LostArkEvent_LostArkEventSchedule schedule, {bool shouldReschedule = false}) async {
    'Removing the alarm for event: ${event.fallbackName}'.logInfo();
    final String alarmString = schedule.timeStart.toString();
    final String sharedKey = '$kSharedKeyEventAlarms${event.id}';

    final List<String> timeList = sharedPreferences.getStringList(sharedKey) ?? <String>[];

    //* Check if shared pref list contains the time then remove it
    timeList.removeWhere((element) => element == alarmString);
    await sharedPreferences.setStringList(sharedKey, timeList);
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: false));
    'Removed the alarm from event ${event.fallbackName} at time: ${schedule.timeStart}'.logInfo();

    if (shouldReschedule) {
      await scheduleNotifications();
    }
  }

  Iterable<String> getSingleAlarmKeys() {
    return sharedPreferences.getKeys().where((element) => element.startsWith(kSharedKeyEventAlarms));
  }

  Iterable<String> getAllAlarmKeys() {
    return sharedPreferences.getKeys().where((element) => element.startsWith(kSharedKeyEventAlarms) || element.startsWith(kSharedKeyEventGlobalAlarm));
  }

  Future<int> countSingleAlarms() async {
    int count = 0;
    for (final String key in getSingleAlarmKeys()) {
      count += (sharedPreferences.getStringList(key) ?? <String>[]).length;
    }
    return count;
  }

  Future<void> cleanupAlarms() async {
    final Iterable<String> keys = getSingleAlarmKeys();
    for (final String key in keys) {
      final List<String> alarmList = sharedPreferences.getStringList(key) ?? <String>[];
      final List<String> returnAlarmList = <String>[];

      for (final String alarmString in alarmList) {
        DateTime? decodedAlarm = DateTime.tryParse(alarmString);
        if (decodedAlarm != null && decodedAlarm.compareTo(DateTime.now()) >= 0) {
          returnAlarmList.add(alarmString);
        }
      }
      sharedPreferences.setStringList(key, returnAlarmList);
    }
  }

  Future<void> clearAllAlarms() async {
    final Iterable<String> keys = getAllAlarmKeys();
    for (final String key in keys) {
      sharedPreferences.remove(key);
    }
  }

  Color getScheduleColour(LostArkEvent event, LostArkEvent_LostArkEventSchedule schedule) {
    switch (schedule.getEventTense) {
      case EventScheduleTense.past:
        return Colors.grey;
      case EventScheduleTense.future:
        if (isSingleAlarmActive(event, schedule)) {
          return Colors.orange;
        }
        return Colors.greenAccent;
      default:
        return Colors.orange;
    }
  }
}
