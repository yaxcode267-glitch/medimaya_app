import '../../shared/model/clinical_section.dart';

const consultationFieldsSection = ClinicalSection(
  slug: "consultation-fields",
  title: "Campos de consulta",
  singular: "campo",
  description: "Campos reutilizables para construir formularios clínicos.",
  tableFields: ['Etiqueta', 'Tipo', 'Obligatorio'],
  filterField: 'Tipo',
  fields: [
    ClinicalField("Disponibilidad", options: ["Activo", "Inactivo"]),
    ClinicalField("Etiqueta", required: true),
    ClinicalField(
      "Tipo",
      options: [
        "Texto",
        "Texto largo",
        "Número",
        "Fecha",
        "Selección",
        "Casilla",
        "Opción única",
      ],
    ),
    ClinicalField("Obligatorio", options: ["Sí", "No"]),
  ],
  examples: [
    {
      "Disponibilidad": "Activo",
      "Etiqueta": "Motivo de consulta",
      "Tipo": "Texto largo",
      "Obligatorio": "Sí",
    },
    {
      "Disponibilidad": "Inactivo",
      "Etiqueta": "Observaciones",
      "Tipo": "Texto largo",
      "Obligatorio": "No",
    },
  ],
);

const consultationFieldExampleConfigs = <String, Map<String, Object?>>{
  'demo-1': {'placeholder': 'Describe el motivo de la visita'},
  'demo-2': {'placeholder': 'Anota las observaciones de la consulta'},
};
