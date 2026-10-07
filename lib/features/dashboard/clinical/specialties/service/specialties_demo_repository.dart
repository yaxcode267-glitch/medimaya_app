import '../model/specialty.dart';
import '../../shared/service/clinical_repository.dart';

final specialtiesRepository = DemoClinicalRepository<Specialty>([
  Specialty.fromJson({
    "id": "demo-1",
    "active": true,
    "name": "Medicina general",
    "description": "Atención integral y seguimiento.",
  }),
  Specialty.fromJson({
    "id": "demo-2",
    "active": false,
    "name": "Pediatría",
    "description": "Atención de niños y adolescentes.",
  }),
]);
