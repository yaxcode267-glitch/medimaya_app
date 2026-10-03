import 'package:medimaya_app/shared/utils/date_utils.dart';

/// Ficha del portal de paciente (`GET /auth/paciente/perfil`).
class PatientProfile {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final String gender;
  final DateTime? lastLoginAt;

  const PatientProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.birthDate,
    this.gender = 'Sin especificar',
    this.lastLoginAt,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      birthDate: DateUtils.tryParse(json['birth_date']),
      gender: genderLabel(json['gender']),
      lastLoginAt: DateUtils.tryParse(json['last_login_at']),
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  int get age {
    final birth = birthDate;
    if (birth == null) return 0;

    final today = DateTime.now();
    final hadBirthday =
        today.month > birth.month ||
        (today.month == birth.month && today.day >= birth.day);

    final years = today.year - birth.year;
    return hadBirthday ? years : years - 1;
  }

  /// La API guarda el género como `M`, `F` u `OTRO`.
  static String genderLabel(Object? value) {
    return switch (value?.toString().toUpperCase()) {
      'M' => 'Masculino',
      'F' => 'Femenino',
      'OTRO' => 'Otro',
      _ => 'Sin especificar',
    };
  }
}
