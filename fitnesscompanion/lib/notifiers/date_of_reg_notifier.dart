import 'package:flutter/widgets.dart';

class DateOfRegNotifier with ChangeNotifier {
  String _dateOfReg;

  String get dateOfReg => _dateOfReg;

  void setDateOfReg(String dateOfReg) {
    _dateOfReg = dateOfReg;
    notifyListeners();
  }
}