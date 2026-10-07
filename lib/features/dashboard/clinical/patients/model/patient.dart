import '../../shared/model/clinical_record.dart';

class Patient implements ClinicalRecord {
  const Patient({
    required this.id,
    required this.active,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.sex,
    required this.phone,
    required this.email,
    required this.patientCode,
  });
  @override
  final String id;
  @override
  final bool active;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String sex;
  final String phone;
  final String email;
  final String patientCode;
  factory Patient.fromJson(Map<String, Object?> json) => Patient(
    id: json['id'] as String,
    active: json['active'] as bool,
    firstName: json['first_name'] as String? ?? '',
    lastName: json['last_name'] as String? ?? '',
    birthDate: json['birth_date'] as String? ?? '',
    sex: json['sex'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    email: json['email'] as String? ?? '',
    patientCode: json['patient_code'] as String? ?? '',
  );
  @override
  Map<String, Object?> toJson() => {
    'id': id,
    'active': active,
    'first_name': firstName,
    'last_name': lastName,
    'birth_date': birthDate,
    'sex': sex,
    'phone': phone,
    'email': email,
    'patient_code': patientCode,
  };
  @override
  Map<String, String> toValues() => {
    'id': id,
    'active': active ? 'Activo' : 'Inactivo',
    'first_name': firstName,
    'last_name': lastName,
    'birth_date': birthDate,
    'sex': sex,
    'phone': phone,
    'email': email,
    'patient_code': patientCode,
  };
}
