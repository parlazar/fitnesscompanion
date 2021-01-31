import 'package:flutter/widgets.dart';

class TargetCalsNotifier with ChangeNotifier {
  int _targetCals;

  int get targetCals => _targetCals;

  void setTargetCals(int targetCals) {
    _targetCals = targetCals;
    notifyListeners();
  }
}