/// Permiso individual (ej: "roles:view").
class Permission {
  final String id;
  final String name;

  const Permission({required this.id, required this.name});

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

/// Grupo de permisos devuelto por `/roles/permissions`.
///
/// El backend agrupa los permisos en categorías (ej: "Roles") y dentro
/// de cada grupo vienen los permisos sueltos.
class PermissionGroup {
  final String id;
  final String slug;
  final String name;
  final List<Permission> permissions;

  const PermissionGroup({
    required this.id,
    required this.slug,
    required this.name,
    this.permissions = const [],
  });

  factory PermissionGroup.fromJson(Map<String, dynamic> json) {
    return PermissionGroup(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      permissions:
          (json['permissions'] as List?)
              ?.map(
                (e) => Permission.fromJson((e as Map).cast<String, dynamic>()),
              )
              .toList() ??
          const [],
    );
  }
}
