/// Modelo de usuario usado en auditoría de entidades
/// (`created_by`, `updated_by`, `deleted_by`). Refleja `UserProfile`
/// del backend.
class UserProfile {
  final String id;
  final String email;
  final String names;
  final String surnames;
  final String? profile;

  const UserProfile({
    required this.id,
    required this.email,
    required this.names,
    required this.surnames,
    this.profile,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      names: json['names']?.toString() ?? '',
      surnames: json['surnames']?.toString() ?? '',
      profile: json['profile']?.toString(),
    );
  }

  /// Lee un usuario que puede venir como `null` (auditoría opcional).
  /// Devuelve `null` si el valor no es un mapa.
  static UserProfile? tryParse(Object? value) {
    if (value is! Map) return null;
    return UserProfile.fromJson(value.cast<String, dynamic>());
  }

  String get fullName => '$names $surnames'.trim();
}
