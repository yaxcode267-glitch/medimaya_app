/// Rol para listar (resumen).
class Role {
  final String id;
  final String name;
  final String? description;
  final bool active;
  final DateTime? deletedAt;

  const Role({
    required this.id,
    required this.name,
    this.description,
    this.active = true,
    this.deletedAt,
  });

  bool get deleted => deletedAt != null;

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      active: json['active'] == true,
      deletedAt: DateTime.tryParse(json['deleted_at'] as String? ?? ''),
    );
  }
}

/// Cuerpo que se envía al crear o editar un rol (POST/PUT `/roles`).
class RolePayload {
  final String name;
  final String? description;
  final List<String> permissions;

  const RolePayload({
    required this.name,
    this.description,
    this.permissions = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null && description!.trim().isNotEmpty)
        'description': description,
      'permissions': permissions,
    };
  }
}
