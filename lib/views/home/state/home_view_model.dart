import 'package:inqvine_core_main/inqvine_core_main.dart';

class HomeViewModel extends BaseViewModel {
  int _currentHomeIndex = 0;
  int get currentHomeIndex => _currentHomeIndex;
  set currentHomeIndex(int index) {
    _currentHomeIndex = index;
    notifyListeners();
  }
}
