import '../../shared/model/clinical_record.dart';
import '../../consultation_forms/model/form_builder_models.dart';

class ClinicalFieldRecord implements ClinicalRecord {
  const ClinicalFieldRecord({
    required this.id,
    required this.active,
    required this.label,
    required this.fieldType,
    required this.required,
    this.config = const {},
  });
  @override
  final String id;
  @override
  final bool active;
  final String label;
  final String fieldType;
  final bool required;
  final Map<String, Object?> config;
  factory ClinicalFieldRecord.fromJson(Map<String, Object?> json) =>
      ClinicalFieldRecord(
        id: json['id'] as String,
        active: json['active'] as bool,
        label: json['label'] as String? ?? '',
        fieldType: json['field_type'] as String? ?? '',
        required: json['required'] as bool,
        config: (json['config'] as Map<String, Object?>?) ?? const {},
      );
  @override
  Map<String, Object?> toJson() => {
    'id': id,
    'active': active,
    'label': label,
    'field_type': fieldType,
    'required': required,
    'config': config,
  };
  @override
  Map<String, String> toValues() => {
    'id': id,
    'active': active ? 'Activo' : 'Inactivo',
    'label': label,
    'field_type': consultationFieldTypes[fieldType] ?? fieldType,
    'required': required ? 'Sí' : 'No',
  };
}
