class ProfileUser {
  final String id;
  final String email;
  final String names;
  final String surnames;
  final String? profile;

  const ProfileUser({
    required this.id,
    required this.email,
    required this.names,
    required this.surnames,
    this.profile,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      names: json['names']?.toString() ?? '',
      surnames: json['surnames']?.toString() ?? '',
      profile: json['profile']?.toString(),
    );
  }
}

class ProfileRole {
  final String id;
  final String name;

  const ProfileRole({required this.id, required this.name});

  factory ProfileRole.fromJson(Map<String, dynamic> json) {
    return ProfileRole(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class ProfileResponse {
  final ProfileUser user;
  final ProfileRole? role;
  final List<String> permissions;

  const ProfileResponse({
    required this.user,
    this.role,
    this.permissions = const [],
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      user: ProfileUser.fromJson(
        (json['user'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      role: json['role'] == null
          ? null
          : ProfileRole.fromJson((json['role'] as Map).cast<String, dynamic>()),
      permissions:
          (json['permissions'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }

  /// Construye la respuesta a partir del modelo de usuario plano que devuelve
  /// `GET /user`, sin envoltorio ni rol.
  factory ProfileResponse.fromUser(Map<String, dynamic> json) {
    return ProfileResponse(user: ProfileUser.fromJson(json));
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': user.id,
        'email': user.email,
        'names': user.names,
        'surnames': user.surnames,
        if (user.profile != null) 'profile': user.profile,
      },
      if (role != null) 'role': {'id': role!.id, 'name': role!.name},
      'permissions': permissions,
    };
  }
}
