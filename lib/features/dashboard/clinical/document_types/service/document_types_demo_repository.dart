import '../model/document_type.dart';
import '../../shared/service/clinical_repository.dart';

final documentTypesRepository = DemoClinicalRepository<DocumentType>([
  DocumentType.fromJson({
    "id": "demo-1",
    "active": true,
    "name": "Laboratorio",
    "description": "Resultados de exámenes.",
    "allowed_extensions": ["pdf", "jpg", "png"],
    "max_size_mb": 10,
  }),
  DocumentType.fromJson({
    "id": "demo-2",
    "active": false,
    "name": "Imagen diagnóstica",
    "allowed_extensions": ["pdf", "jpg", "png"],
    "max_size_mb": 20,
    "description": "",
  }),
]);
