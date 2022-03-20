// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'context_extensions.dart';
import 'package:pocketark/extensions/number_extensions.dart';
import 'package:pocketark/proto/events.pb.dart';

extension EventExtensions on LostArkEvent {
  String getEventTypeAsString(BuildContext context) {
    switch (type) {
      case 1:
        return context.localizations!.eventTypePvP;
      case 2:
        return context.localizations!.eventTypeCapture;
      case 3:
        return context.localizations!.eventTypeChaosGate;
      case 4:
        return context.localizations!.eventTypeFieldBoss;
      case 5:
        return context.localizations!.eventTypeAdventureIsland;
      case 6:
        return context.localizations!.eventTypeGhostShip;
      case 7:
        return context.localizations!.eventTypeIsland;
      case 8:
        return context.localizations!.eventTypeSailing;
      case 9:
        return context.localizations!.eventTypeSiege;
      case 10:
        return context.localizations!.eventTypeProvingGrounds;
      default:
        return context.localizations!.eventTypeUnknown;
    }
  }

  LostArkEvent_LostArkEventSchedule get getNextEventTime {
    LostArkEvent_LostArkEventSchedule returnSchedule = LostArkEvent_LostArkEventSchedule();
    Duration timeUntilReturnEvent = Duration(days: 5);
    for (LostArkEvent_LostArkEventSchedule schedule in this.schedule) {
      if (schedule.timeUntilEvent < timeUntilReturnEvent && schedule.timeUntilEvent >= Duration.zero) {
        returnSchedule = schedule;
        timeUntilReturnEvent = returnSchedule.timeUntilEvent;
      }
    }
    return returnSchedule;
  }

  String get getNextEventTimeAsString {
    LostArkEvent_LostArkEventSchedule nextEventSchedule = getNextEventTime;
    Duration nextEventTime = nextEventSchedule.timeUntilEvent;
    return nextEventTime.inSeconds.getTimeAsStringFromMinute;
  }
}

extension ScheduleExtensions on LostArkEvent_LostArkEventSchedule {
  String get getEventStartTimeAsString {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStart.toInt());
    // return dateTime.toIso8601String();
    return "${dateTime.hour}:${dateTime.minute}";
  }

  String get getEventTimeAsString {
    if (timeEnd != -1) {
      final DateTime dateTimeStart = DateTime.fromMillisecondsSinceEpoch(timeStart.toInt());
      final DateTime dateTimeEnd = DateTime.fromMillisecondsSinceEpoch(timeEnd.toInt());
      return "${dateTimeStart.hour}:${dateTimeStart.minute} - ${dateTimeEnd.hour}:${dateTimeEnd.minute}";
    } else {
      return getEventStartTimeAsString;
    }
  }

  EventScheduleTense get getEventTense {
    final Duration timeUntilEventLocal = timeUntilEvent;

    //! Change duration minutes to a configurable setting
    if (timeUntilEventLocal >= Duration(minutes: -1) && timeUntilEventLocal <= Duration(minutes: 30)) {
      return EventScheduleTense.present;
    } else {
      if (timeUntilEventLocal > Duration.zero) {
        return EventScheduleTense.future;
      } else {
        return EventScheduleTense.past;
      }
    }
  }

  Duration get timeUntilEvent {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStart.toInt());
    final DateTime dateTimeNow = DateTime.now().toUtc();
    return dateTime.difference(dateTimeNow);
  }

  Color get getScheduleColour {
    switch (getEventTense) {
      case EventScheduleTense.past:
        return Colors.grey;
      case EventScheduleTense.future:
        return Colors.greenAccent;
      default:
        return Colors.orange;
        return Colors.green;
    }
  }
}

enum EventScheduleTense {
  past,
  present,
  future,
}
