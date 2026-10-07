import '../service/consultation_fields_demo_repository.dart';
import '../../shared/model/clinical_section.dart';

final consultationFieldsSection = ClinicalSection(
  slug: "consultation-fields",
  title: "Campos de consulta",
  singular: "campo",
  description: "Campos reutilizables para construir formularios clínicos.",
  tableFields: ['label', 'field_type', 'required'],
  filterField: 'field_type',
  fields: [
    ClinicalField(
      "Disponibilidad",
      key: "active",
      options: ["Activo", "Inactivo"],
    ),
    ClinicalField("Etiqueta", key: "label", required: true),
    ClinicalField(
      "Tipo",
      key: "field_type",
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
    ClinicalField("Obligatorio", key: "required", options: ["Sí", "No"]),
  ],
  repository: consultationFieldsRepository,
);
