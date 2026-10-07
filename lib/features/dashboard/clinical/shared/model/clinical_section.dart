class ClinicalSection {
  const ClinicalSection({
    required this.slug,
    required this.title,
    required this.singular,
    required this.description,
    required this.fields,
    required this.examples,
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
  final List<Map<String, String>> examples;
  String get path => '/dashboard/$slug';
}

class ClinicalField {
  const ClinicalField(
    this.label, {
    this.options = const [],
    this.multiline = false,
    this.date = false,
    this.required = false,
  });
  final String label;
  final List<String> options;
  final bool multiline;
  final bool date;
  final bool required;
}
