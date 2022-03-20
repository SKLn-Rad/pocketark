extension IntExtention on int {
  String get getTimeAsStringFromMinute {
    final num remainingSeconds = remainder(60);
    final num minutes = (this / 60);
    final num remainingMinutes = minutes.remainder(60);
    final num hours = minutes / 60;

    final String hoursString = hours.floor().toString().padLeft(2, '0');
    final String minutesString = remainingMinutes.floor().toString().padLeft(2, '0');
    final String secondsString = remainingSeconds.toString().padLeft(2, '0');

    return "$hoursString:$minutesString:$secondsString";
  }
}
