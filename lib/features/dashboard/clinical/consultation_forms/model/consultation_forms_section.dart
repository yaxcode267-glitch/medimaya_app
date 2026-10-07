import '../service/consultation_forms_demo_repository.dart';
import '../../shared/model/clinical_section.dart';

final consultationFormsSection = ClinicalSection(
  slug: "consultation-forms",
  title: "Formularios de consulta",
  singular: "formulario",
  description: "Plantillas organizadas por especialidad, secciones y campos.",
  tableFields: ['name', 'specialty_name', 'status'],
  filterField: 'specialty_name',
  fields: [
    ClinicalField(
      "Disponibilidad",
      key: "active",
      options: ["Activo", "Inactivo"],
    ),
    ClinicalField("Nombre", key: "name", required: true),
    ClinicalField(
      "Especialidad",
      key: "specialty_name",
      options: ["Medicina general", "Pediatría"],
    ),
    ClinicalField("Descripción", key: "description", multiline: true),
    ClinicalField("Estado", key: "status", options: ["Borrador", "Publicado"]),
  ],
  repository: consultationFormsRepository,
);
