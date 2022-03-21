import '../proto/events.pb.dart';

class LostArkEventSchedule {
  LostArkEventSchedule(this.event);

  final LostArkEvent event;

  final List<DateTime> _timesScheduled = <DateTime>[];

  List<DateTime> get getAlarms {
    return _timesScheduled;
  }

  void addAlarm(DateTime dateTime) {
    _timesScheduled.add(dateTime);
  }

  void removeAlarm(DateTime dateTime) {
    _timesScheduled.removeWhere((element) => element == dateTime);
  }

  void clearAlarms() {
    _timesScheduled.clear();
  }
}
