class UserSummary {
  const UserSummary({
    required this.id,
    required this.fullName,
    required this.email,
    required this.active,
    this.roleName,
    this.profile,
    this.deletedAt,
  });
  final String id;
  final String fullName;
  final String email;
  final bool active;
  final String? roleName, profile;
  final DateTime? deletedAt;

  factory UserSummary.fromJson(Map<String, dynamic> json) => UserSummary(
    id: json['id'] as String,
    fullName: json['full_name'] as String,
    email: json['email'] as String,
    active: json['active'] as bool,
    roleName: json['rol_name'] as String?,
    profile: json['profile'] as String?,
    deletedAt: DateTime.tryParse(json['deleted_at']?.toString() ?? ''),
  );
}

class UserDetail {
  UserDetail.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      names = json['names'] as String,
      surnames = json['surnames'] as String,
      email = json['email'] as String,
      active = json['active'] as bool,
      roleId = json['role_id'] as String?,
      roleName = (json['role'] as Map?)?['name'] as String?,
      roleLocked = json['role_locked'] == true,
      hasAudit = json.containsKey('created_at'),
      profile = json['profile'] as String?,
      createdAt = DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt = DateTime.tryParse(json['updated_at']?.toString() ?? ''),
      deletedAt = DateTime.tryParse(json['deleted_at']?.toString() ?? ''),
      createdBy = _actor(json['created_by']),
      updatedBy = _actor(json['updated_by']),
      deletedBy = _actor(json['deleted_by']),
      permissions = (json['permissions'] as List? ?? [])
          .map(
            (group) => (
              name: group['name'] as String,
              items: (group['permissions'] as List)
                  .map((item) => item['name'] as String)
                  .toList(),
            ),
          )
          .toList();
  final String id, names, surnames, email;
  final bool active, roleLocked, hasAudit;
  final String? roleId, roleName, profile;
  final DateTime? createdAt, updatedAt, deletedAt;
  final String? createdBy, updatedBy, deletedBy;
  final List<({String name, List<String> items})> permissions;
  String get fullName => '$names $surnames'.trim();

  static String? _actor(Object? value) {
    if (value is! Map) return null;
    final name = '${value['names'] ?? ''} ${value['surnames'] ?? ''}'.trim();
    return name.isNotEmpty ? name : value['email'] as String?;
  }
}

class UserRole {
  const UserRole({required this.id, required this.name, this.description});
  final String id, name;
  final String? description;
  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
  );
}

class UserInput {
  const UserInput({
    required this.names,
    required this.surnames,
    required this.email,
    this.roleId,
  });
  final String names, surnames, email;
  final String? roleId;
  Map<String, dynamic> toJson() => {
    'names': names.trim(),
    'surnames': surnames.trim(),
    'email': email.trim(),
    if (roleId != null) 'role_id': roleId,
  };
}
