abstract interface class ClinicalRecord {
  String get id;
  bool get active;
  Map<String, Object?> toJson();
  Map<String, String> toValues();
}
