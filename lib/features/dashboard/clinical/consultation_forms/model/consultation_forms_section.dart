import '../../shared/model/clinical_section.dart';

const consultationFormsSection = ClinicalSection(
  slug: "consultation-forms",
  title: "Formularios de consulta",
  singular: "formulario",
  description: "Plantillas organizadas por especialidad, secciones y campos.",
  tableFields: ['Nombre', 'Especialidad', 'Estado'],
  filterField: 'Especialidad',
  fields: [
    ClinicalField("Disponibilidad", options: ["Activo", "Inactivo"]),
    ClinicalField("Nombre", required: true),
    ClinicalField("Especialidad", options: ["Medicina general", "Pediatría"]),
    ClinicalField("Descripción", multiline: true),
    ClinicalField("Estado", options: ["Borrador", "Publicado"]),
  ],
  examples: [
    {
      "Disponibilidad": "Activo",
      "Nombre": "Consulta general",
      "Especialidad": "Medicina general",
      "Descripción": "Evaluación inicial y seguimiento.",
      "Estado": "Publicado",
    },
    {
      "Disponibilidad": "Inactivo",
      "Nombre": "Control de seguimiento",
      "Especialidad": "Pediatría",
      "Estado": "Borrador",
    },
  ],
);
