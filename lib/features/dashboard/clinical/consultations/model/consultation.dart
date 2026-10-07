import '../../shared/model/clinical_record.dart';

class Consultation implements ClinicalRecord {
  const Consultation({
    required this.id,
    required this.active,
    required this.patientName,
    required this.patientId,
    required this.formName,
    required this.formId,
    required this.consultedAt,
    required this.status,
    required this.notes,
  });
  @override
  final String id;
  @override
  final bool active;
  final String patientName;
  final String patientId;
  final String formName;
  final String formId;
  final String consultedAt;
  final String status;
  final String notes;
  factory Consultation.fromJson(Map<String, Object?> json) => Consultation(
    id: json['id'] as String,
    active: json['active'] as bool,
    patientName: json['patient_name'] as String? ?? '',
    patientId: json['patient_id'] as String? ?? '',
    formName: json['form_name'] as String? ?? '',
    formId: json['form_id'] as String? ?? '',
    consultedAt: json['consulted_at'] as String? ?? '',
    status: json['status'] as String? ?? '',
    notes: json['notes'] as String? ?? '',
  );
  @override
  Map<String, Object?> toJson() => {
    'id': id,
    'active': active,
    'patient_name': patientName,
    'patient_id': patientId,
    'form_name': formName,
    'form_id': formId,
    'consulted_at': consultedAt,
    'status': status,
    'notes': notes,
  };
  @override
  Map<String, String> toValues() => {
    'id': id,
    'active': active ? 'Activo' : 'Inactivo',
    'patient_name': patientName,
    'patient_id': patientId,
    'form_name': formName,
    'form_id': formId,
    'consulted_at': consultedAt,
    'status': status,
    'notes': notes,
  };
}
