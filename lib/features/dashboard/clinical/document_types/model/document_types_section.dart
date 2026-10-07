import '../service/document_types_demo_repository.dart';
import '../../shared/model/clinical_section.dart';

final documentTypesSection = ClinicalSection(
  slug: "document-types",
  title: "Tipos de documento",
  singular: "tipo de documento",
  description: "Clasificación de los archivos del expediente clínico.",
  tableFields: ['name', 'allowed_extensions', 'max_size_mb'],
  fields: [
    ClinicalField("Nombre", key: "name", required: true),
    ClinicalField("Descripción", key: "description", multiline: true),
    ClinicalField(
      "Extensiones permitidas",
      key: "allowed_extensions",
      required: true,
      multiline: true,
    ),
    ClinicalField("Tamaño máximo (MB)", key: "max_size_mb", required: true),
    ClinicalField(
      "Disponibilidad",
      key: "active",
      options: ["Activo", "Inactivo"],
    ),
  ],
  repository: documentTypesRepository,
);
