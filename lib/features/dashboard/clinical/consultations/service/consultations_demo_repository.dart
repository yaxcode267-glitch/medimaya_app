import '../model/consultation.dart';
import '../../shared/service/clinical_repository.dart';

final consultationsRepository = DemoClinicalRepository<Consultation>([
  Consultation.fromJson({
    "id": "demo-1",
    "active": true,
    "patient_name": "Paciente de ejemplo Demo",
    "form_name": "Consulta general",
    "consulted_at": "2026-10-06",
    "status": "Borrador",
    "patient_id": "demo-1",
    "form_id": "demo-1",
    "notes": "",
  }),
  Consultation.fromJson({
    "id": "demo-2",
    "active": false,
    "patient_name": "Segundo paciente Demo",
    "form_name": "Control de seguimiento",
    "consulted_at": "2026-10-05",
    "status": "Completada",
    "patient_id": "demo-2",
    "form_id": "demo-2",
    "notes": "",
  }),
]);
