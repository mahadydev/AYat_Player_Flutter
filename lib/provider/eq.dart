import 'package:flutter/material.dart';

class Eq with ChangeNotifier {
  bool _enableCustomEQ = false;
  bool get enableCustomEQ => _enableCustomEQ;
  String _selectedPresetEq = 'Available Preset';
  String get selectedPresetEq => _selectedPresetEq;

  switchEqualizer(bool value) {
    this._enableCustomEQ = value;
    notifyListeners();
  }

  setSelectedEq(String value) {
    this._selectedPresetEq = value;
    notifyListeners();
  }
}
