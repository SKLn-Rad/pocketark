class FutureHelpers {
  static Future<void> runFutureWithMinimumTime(Future<void> Function() function, {int milliseconds = 1500}) async {
    final int expectedTime = DateTime.now().millisecondsSinceEpoch + milliseconds;
    await function();

    while (DateTime.now().millisecondsSinceEpoch > expectedTime) {
      await Future<void>.delayed(const Duration(milliseconds: 25));
    }
  }
}
