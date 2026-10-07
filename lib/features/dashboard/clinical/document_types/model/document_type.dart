import '../../shared/model/clinical_record.dart';

class DocumentType implements ClinicalRecord {
  const DocumentType({
    required this.id,
    required this.active,
    required this.name,
    required this.description,
    required this.allowedExtensions,
    required this.maxSizeMb,
  });
  @override
  final String id;
  @override
  final bool active;
  final String name;
  final String description;
  final List<String> allowedExtensions;
  final int maxSizeMb;
  factory DocumentType.fromJson(Map<String, Object?> json) => DocumentType(
    id: json['id'] as String,
    active: json['active'] as bool,
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    allowedExtensions: (json['allowed_extensions'] as List).cast<String>(),
    maxSizeMb: json['max_size_mb'] as int,
  );
  @override
  Map<String, Object?> toJson() => {
    'id': id,
    'active': active,
    'name': name,
    'description': description,
    'allowed_extensions': allowedExtensions,
    'max_size_mb': maxSizeMb,
  };
  @override
  Map<String, String> toValues() => {
    'id': id,
    'active': active ? 'Activo' : 'Inactivo',
    'name': name,
    'description': description,
    'allowed_extensions': allowedExtensions.join(', '),
    'max_size_mb': maxSizeMb.toString(),
  };
}
