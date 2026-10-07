import '../../shared/model/clinical_section.dart';

const documentTypesSection = ClinicalSection(
  slug: "document-types",
  title: "Tipos de documento",
  singular: "tipo de documento",
  description: "Clasificación de los archivos del expediente clínico.",
  tableFields: ['Nombre', 'Extensiones permitidas', 'Tamaño máximo (MB)'],
  fields: [
    ClinicalField("Nombre", required: true),
    ClinicalField("Descripción", multiline: true),
    ClinicalField("Extensiones permitidas", required: true, multiline: true),
    ClinicalField("Tamaño máximo (MB)", required: true),
    ClinicalField("Disponibilidad", options: ["Activo", "Inactivo"]),
  ],
  examples: [
    {
      "Nombre": "Laboratorio",
      "Descripción": "Resultados de exámenes.",
      "Extensiones permitidas": "pdf, jpg, png",
      "Tamaño máximo (MB)": "10",
      "Disponibilidad": "Activo",
    },
    {
      "Nombre": "Imagen diagnóstica",
      "Extensiones permitidas": "pdf, jpg, png",
      "Tamaño máximo (MB)": "20",
      "Disponibilidad": "Inactivo",
    },
  ],
);
