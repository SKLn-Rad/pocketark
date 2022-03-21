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
import '../structure/lost_ark_event_schedule.dart';

class EventService extends InqvineServiceBase with PocketArkServiceMixin {
  static const String kEventCollectionName = 'events';
  static CollectionReference get kEventCollection => inqvine.getFromLocator<FirebaseFirestore>().collection(EventService.kEventCollectionName);

  ScheduledTask? notificationScheduleTask;
  StreamSubscription<User?>? userSubscription;
  StreamSubscription<QuerySnapshot<Object?>>? eventsSubscription;

  //* All events detected
  final BiMap<QueryDocumentSnapshot, LostArkEventSchedule> eventSchedules = BiMap();

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
    eventSchedules.clear();
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: true));

    if (user == null) {
      return;
    }

    'Listening for new events'.logDebug();
    eventsSubscription = kEventCollection.snapshots().listen(onEventsChanged);
  }

  void onEventsChanged(QuerySnapshot<Object?> eventQuerySnapshot) {
    'Detected events changed'.logInfo();
    eventSchedules.clear();

    for (final QueryDocumentSnapshot<Object?> eventSnapshot in eventQuerySnapshot.docs) {
      final LostArkEvent event = LostArkEvent.create()..mergeFromProto3Json(eventSnapshot.data(), ignoreUnknownFields: true);
      eventSchedules.putIfAbsent(eventSnapshot, () => LostArkEventSchedule(event));
    }

    'Found ${eventSchedules.length} new eventSchedules'.logInfo();
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: true));
    unawaited(scheduleNotifications());
  }

  Future<void> scheduleNotifications() async {
    // Unschedule all notifications
    //* should this be the case? or should we keep track of notifications and only update the ones needed?
    await localNotifications.cancelAll();

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

    for (final LostArkEventSchedule eventSchedule in eventSchedules.values) {
      if (!isGlobalEventAlarmActive(eventSchedule.event)) {
        for (DateTime time in eventSchedule.getAlarms) {
          //! I am unsure if tz.UTC is correct here, I need to check what the "time" variable from getAlarms is:
          final tz.TZDateTime scheduleTime = tz.TZDateTime.from(time, tz.UTC).subtract(Duration(minutes: timeMinutesBeforeNotification));
          final tz.TZDateTime currentTime = tz.TZDateTime.now(tz.UTC);

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
            eventSchedule.event.eventNameWithItemLevel,
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
        return;
      }

      for (final LostArkEvent_LostArkEventSchedule schedule in eventSchedule.event.schedule) {
        final tz.TZDateTime scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.UTC, schedule.timeStart.toInt()).subtract(Duration(minutes: timeMinutesBeforeNotification));
        final tz.TZDateTime currentTime = tz.TZDateTime.now(tz.UTC);

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
          eventSchedule.event.eventNameWithItemLevel,
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
    for (final LostArkEventSchedule eventSchedule in eventSchedules.values) {
      await enableGlobalEventAlarm(eventSchedule.event);
    }

    await scheduleNotifications();
  }

  Future<void> disableAllGlobalEventAlarms() async {
    for (final LostArkEventSchedule eventSchedule in eventSchedules.values) {
      await disableGlobalEventAlarm(eventSchedule.event);
    }

    await scheduleNotifications();
  }

  Future<void> enableGlobalEventAlarm(LostArkEvent event, {bool shouldReschedule = false}) async {
    'Unmuting event: ${event.fallbackName}'.logInfo();
    final String sharedKey = '$kSharedKeyEventGlobalAlarm${event.id}';

    //? set global event alarm to on (true)
    await sharedPreferences.setBool(sharedKey, true);
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: false));

    if (shouldReschedule) {
      await scheduleNotifications();
    }
  }

  Future<void> disableGlobalEventAlarm(LostArkEvent event, {bool shouldReschedule = false}) async {
    'Muting event: ${event.fallbackName}'.logInfo();
    final String sharedKey = '$kSharedKeyEventGlobalAlarm${event.id}';

    //? set global event alarm to off (false)
    await sharedPreferences.setBool(sharedKey, false);
    inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: false));

    if (shouldReschedule) {
      await scheduleNotifications();
    }
  }

  Future<void> addAlarm(LostArkEventSchedule eventSchedule, DateTime alarmDateTime, {bool shouldReschedule = false}) async {
    'Muting event: ${eventSchedule.event.fallbackName}'.logInfo();
    final String alarmString = alarmDateTime.toString();
    final String sharedKey = '$kSharedKeyEventAlarms${eventSchedule.event.id}';

    final List<String> timeList = sharedPreferences.getStringList(sharedKey) ?? <String>[];

    //* Check if shared pref list contains the time already, otherwise add it
    if (timeList.contains(alarmString)) {
    } else {
      timeList.add(alarmString);
      await sharedPreferences.setStringList(sharedKey, timeList);
      inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: false));
    }

    if (shouldReschedule) {
      await scheduleNotifications();
    }
  }

  Future<void> removeAlarm(LostArkEventSchedule eventSchedule, DateTime alarmDateTime, {bool shouldReschedule = false}) async {
    'Removing the alarm for event: ${eventSchedule.event.fallbackName}'.logInfo();
    final String alarmString = alarmDateTime.toString();
    final String sharedKey = '$kSharedKeyEventAlarms${eventSchedule.event.id}';

    final List<String> timeList = sharedPreferences.getStringList(sharedKey) ?? <String>[];

    //* Check if user data for this event exists
    if (sharedPreferences.containsKey(sharedKey)) {
      //* Check if shared pref list contains the time then remove it
      if (timeList.contains(alarmString)) {
        timeList.removeWhere((element) => element == alarmString);
        await sharedPreferences.setStringList(sharedKey, timeList);
        inqvine.publishEvent(const EventsUpdatedEvent(shouldSort: false));
        'Removed the alarm from event ${eventSchedule.event.fallbackName} at time: ${alarmDateTime}'.logInfo();
      } else {
        'Alarm not found'.logInfo();
      }
    } else {
      'Could not find event ${eventSchedule.event.fallbackName} in user preferances'.logInfo();
    }

    if (shouldReschedule) {
      await scheduleNotifications();
    }
  }
}
