import '../../shared/model/clinical_record.dart';

class ConsultationForm implements ClinicalRecord {
  const ConsultationForm({
    required this.id,
    required this.active,
    required this.name,
    required this.specialtyName,
    required this.specialtyId,
    required this.description,
    required this.status,
  });
  @override
  final String id;
  @override
  final bool active;
  final String name;
  final String specialtyName;
  final String specialtyId;
  final String description;
  final String status;
  factory ConsultationForm.fromJson(Map<String, Object?> json) =>
      ConsultationForm(
        id: json['id'] as String,
        active: json['active'] as bool,
        name: json['name'] as String? ?? '',
        specialtyName: json['specialty_name'] as String? ?? '',
        specialtyId: json['specialty_id'] as String? ?? '',
        description: json['description'] as String? ?? '',
        status: json['status'] as String? ?? '',
      );
  @override
  Map<String, Object?> toJson() => {
    'id': id,
    'active': active,
    'name': name,
    'specialty_name': specialtyName,
    'specialty_id': specialtyId,
    'description': description,
    'status': status,
  };
  @override
  Map<String, String> toValues() => {
    'id': id,
    'active': active ? 'Activo' : 'Inactivo',
    'name': name,
    'specialty_name': specialtyName,
    'specialty_id': specialtyId,
    'description': description,
    'status': status,
  };
}
