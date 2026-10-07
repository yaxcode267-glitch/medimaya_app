import '../../shared/model/clinical_section.dart';

const consultationsSection = ClinicalSection(
  slug: "consultations",
  title: "Consultas",
  singular: "consulta",
  description: "Registro de atención y seguimiento del paciente.",
  tableFields: ['Paciente', 'Formulario', 'Fecha de consulta', 'Estado'],
  filterField: 'Estado',
  fields: [
    ClinicalField("Disponibilidad", options: ["Activo", "Inactivo"]),
    ClinicalField("Paciente", multiline: true),
    ClinicalField(
      "Formulario",
      options: ["Consulta general", "Control de seguimiento"],
    ),
    ClinicalField("Fecha de consulta", date: true),
    ClinicalField("Estado", options: ["Borrador", "Completada", "Cancelada"]),
    ClinicalField("Notas", multiline: true),
  ],
  examples: [
    {
      "Disponibilidad": "Activo",
      "Paciente": "Paciente de ejemplo Demo",
      "Formulario": "Consulta general",
      "Fecha de consulta": "2026-10-06",
      "Estado": "Borrador",
    },
    {
      "Disponibilidad": "Inactivo",
      "Paciente": "Segundo paciente Demo",
      "Formulario": "Control de seguimiento",
      "Fecha de consulta": "2026-10-05",
      "Estado": "Completada",
    },
  ],
);
