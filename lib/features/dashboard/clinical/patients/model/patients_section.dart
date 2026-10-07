import '../../shared/model/clinical_section.dart';

const patientsSection = ClinicalSection(
  slug: "patients",
  title: "Pacientes",
  singular: "paciente",
  description: "Ficha personal y acceso al historial clínico.",
  tableFields: ['Nombres', 'Apellidos', 'ID'],
  filterField: 'Sexo',
  fields: [
    ClinicalField("Disponibilidad", options: ["Activo", "Inactivo"]),
    ClinicalField("Nombres", required: true),
    ClinicalField("Apellidos", required: true),
    ClinicalField("Fecha de nacimiento", date: true),
    ClinicalField("Sexo", options: ["Femenino", "Masculino", "Otro"]),
    ClinicalField("Teléfono"),
    ClinicalField("Correo electrónico"),
    ClinicalField("ID"),
  ],
  examples: [
    {
      "Disponibilidad": "Activo",
      "Nombres": "Paciente de ejemplo",
      "ID": "PAC-DEMO-001",
      "Apellidos": "Demo",
      "Fecha de nacimiento": "1990-01-15",
      "Sexo": "Femenino",
    },
    {
      "Disponibilidad": "Inactivo",
      "Nombres": "Segundo paciente",
      "ID": "PAC-DEMO-002",
      "Apellidos": "Demo",
      "Fecha de nacimiento": "1985-06-20",
      "Sexo": "Masculino",
    },
  ],
);
