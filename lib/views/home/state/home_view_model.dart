import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/services/service_configuration.dart';

class HomeViewModel extends BaseViewModel with PocketArkServiceMixin {
  final PageController currentPageController = PageController(initialPage: 1);

  int _currentHomeIndex = 1;
  int get currentHomeIndex => _currentHomeIndex;

  Future<void> onPageUpdated(int index, {bool shouldAttemptAnimate = true}) async {
    final int delta = max(index, _currentHomeIndex) - min(index, _currentHomeIndex);
    if (shouldAttemptAnimate && delta == 1) {
      currentPageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.decelerate);
    } else if (shouldAttemptAnimate) {
      currentPageController.jumpToPage(index);
    } else {
      _currentHomeIndex = index;
    }

    notifyListeners();
  }
}
