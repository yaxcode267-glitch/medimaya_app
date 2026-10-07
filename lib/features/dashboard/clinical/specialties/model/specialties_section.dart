import '../service/specialties_demo_repository.dart';
import '../../shared/model/clinical_section.dart';

final specialtiesSection = ClinicalSection(
  slug: "specialties",
  title: "Especialidades",
  singular: "especialidad",
  description: "Catálogo de especialidades de atención.",
  tableFields: ['name', 'description'],
  fields: [
    ClinicalField("Nombre", key: "name", required: true),
    ClinicalField("Descripción", key: "description", multiline: true),
    ClinicalField(
      "Disponibilidad",
      key: "active",
      options: ["Activo", "Inactivo"],
    ),
  ],
  repository: specialtiesRepository,
);
