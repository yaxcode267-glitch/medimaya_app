import '../service/consultations_demo_repository.dart';
import '../../shared/model/clinical_section.dart';

final consultationsSection = ClinicalSection(
  slug: "consultations",
  title: "Consultas",
  singular: "consulta",
  description: "Registro de atención y seguimiento del paciente.",
  tableFields: ['patient_name', 'form_name', 'consulted_at', 'status'],
  filterField: 'status',
  fields: [
    ClinicalField(
      "Disponibilidad",
      key: "active",
      options: ["Activo", "Inactivo"],
    ),
    ClinicalField("Paciente", key: "patient_name", multiline: true),
    ClinicalField(
      "Formulario",
      key: "form_name",
      options: ["Consulta general", "Control de seguimiento"],
    ),
    ClinicalField("Fecha de consulta", key: "consulted_at", date: true),
    ClinicalField(
      "Estado",
      key: "status",
      options: ["Borrador", "Completada", "Cancelada"],
    ),
    ClinicalField("Notas", key: "notes", multiline: true),
  ],
  repository: consultationsRepository,
);
