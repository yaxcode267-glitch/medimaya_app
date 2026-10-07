import '../../shared/model/clinical_record.dart';

class Specialty implements ClinicalRecord {
  const Specialty({
    required this.id,
    required this.active,
    required this.name,
    required this.description,
  });
  @override
  final String id;
  @override
  final bool active;
  final String name;
  final String description;
  factory Specialty.fromJson(Map<String, Object?> json) => Specialty(
    id: json['id'] as String,
    active: json['active'] as bool,
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
  );
  @override
  Map<String, Object?> toJson() => {
    'id': id,
    'active': active,
    'name': name,
    'description': description,
  };
  @override
  Map<String, String> toValues() => {
    'id': id,
    'active': active ? 'Activo' : 'Inactivo',
    'name': name,
    'description': description,
  };
}
