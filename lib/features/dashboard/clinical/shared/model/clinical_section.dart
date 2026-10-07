import 'clinical_record.dart';
import '../service/clinical_repository.dart';

class ClinicalSection {
  ClinicalSection({
    required this.slug,
    required this.title,
    required this.singular,
    required this.description,
    required this.fields,
    required this.repository,
    required this.tableFields,
    this.filterField,
  });
  final List<String> tableFields;
  final String? filterField;
  final String slug;
  final String title;
  final String singular;
  final String description;
  final List<ClinicalField> fields;
  final ClinicalRepository<ClinicalRecord> repository;
  List<ClinicalRecord> records = [];
  Future<void>? _loading;
  Future<void> load() => _loading ??= repository.list().then((values) {
    records = values;
  });
  Future<void> reload() {
    _loading = null;
    return load();
  }

  List<Map<String, String>> get rows =>
      records.map((record) => record.toValues()).toList();
  String labelFor(String key) =>
      fields.firstWhere((field) => field.key == key).label;
  int indexOfId(String id) => records.indexWhere((record) => record.id == id);

  String get path => '/dashboard/$slug';
}

class ClinicalField {
  const ClinicalField(
    this.label, {
    required this.key,
    this.options = const [],
    this.multiline = false,
    this.date = false,
    this.required = false,
  });
  final String label;
  final String key;
  final List<String> options;
  final bool multiline;
  final bool date;
  final bool required;
}
