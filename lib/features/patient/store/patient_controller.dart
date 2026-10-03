import 'package:flutter/foundation.dart';

// Model / Service
import '../model/patient_profile.dart';
import '../service/patient_service.dart';

class PatientController extends ChangeNotifier {
  PatientController._();

  static final PatientController instance = PatientController._();

  PatientProfile? profile;
  bool loaded = false;
  bool loading = false;

  Future<void> load() async {
    if (loaded || loading) return;
    await fetch();
  }

  Future<void> fetch() async {
    loading = true;
    notifyListeners();

    try {
      profile = await PatientService().profile();
      loaded = true;
    } on Exception {
      // Sin red o sesión expirada. El portal muestra el error y reintenta.
      loaded = false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void reset() {
    profile = null;
    loaded = false;
    loading = false;
    notifyListeners();
  }
}
