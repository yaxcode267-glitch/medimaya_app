import '../model/consultation_form.dart';
import '../../shared/service/clinical_repository.dart';

final consultationFormsRepository = DemoClinicalRepository<ConsultationForm>([
  ConsultationForm.fromJson({
    "id": "demo-1",
    "active": true,
    "name": "Consulta general",
    "specialty_name": "Medicina general",
    "description": "Evaluación inicial y seguimiento.",
    "status": "Publicado",
    "specialty_id": "demo-1",
  }),
  ConsultationForm.fromJson({
    "id": "demo-2",
    "active": false,
    "name": "Control de seguimiento",
    "specialty_name": "Pediatría",
    "status": "Borrador",
    "specialty_id": "demo-2",
    "description": "",
  }),
]);
