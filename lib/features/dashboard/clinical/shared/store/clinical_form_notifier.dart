import 'package:flutter/foundation.dart';

class ClinicalFormNotifier extends ChangeNotifier {
  ClinicalFormNotifier(Map<String, String> initial) : _values = {...initial};
  final Map<String, String> _values;
  Map<String, String> get values => Map.unmodifiable(_values);
  void setValue(String key, String value) {
    if (_values[key] == value) return;
    _values[key] = value;
    notifyListeners();
  }
}
