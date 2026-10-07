import '../service/patients_demo_repository.dart';
import '../../shared/model/clinical_section.dart';

final patientsSection = ClinicalSection(
  slug: "patients",
  title: "Pacientes",
  singular: "paciente",
  description: "Ficha personal y acceso al historial clínico.",
  tableFields: ['first_name', 'last_name', 'patient_code'],
  filterField: 'sex',
  fields: [
    ClinicalField(
      "Disponibilidad",
      key: "active",
      options: ["Activo", "Inactivo"],
    ),
    ClinicalField("Nombres", key: "first_name", required: true),
    ClinicalField("Apellidos", key: "last_name", required: true),
    ClinicalField("Fecha de nacimiento", key: "birth_date", date: true),
    ClinicalField(
      "Sexo",
      key: "sex",
      options: ["Femenino", "Masculino", "Otro"],
    ),
    ClinicalField("Teléfono", key: "phone"),
    ClinicalField("Correo electrónico", key: "email"),
    ClinicalField("ID", key: "patient_code"),
  ],
  repository: patientsRepository,
);
