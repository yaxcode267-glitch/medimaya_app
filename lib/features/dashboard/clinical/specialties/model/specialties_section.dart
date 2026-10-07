import '../../shared/model/clinical_section.dart';

const specialtiesSection = ClinicalSection(
  slug: "specialties",
  title: "Especialidades",
  singular: "especialidad",
  description: "Catálogo de especialidades de atención.",
  tableFields: ['Nombre', 'Descripción'],
  fields: [
    ClinicalField("Nombre", required: true),
    ClinicalField("Descripción", multiline: true),
    ClinicalField("Disponibilidad", options: ["Activo", "Inactivo"]),
  ],
  examples: [
    {
      "Nombre": "Medicina general",
      "Descripción": "Atención integral y seguimiento.",
      "Disponibilidad": "Activo",
    },
    {
      "Nombre": "Pediatría",
      "Descripción": "Atención de niños y adolescentes.",
      "Disponibilidad": "Inactivo",
    },
  ],
);
