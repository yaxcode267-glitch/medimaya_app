import '../model/patient.dart';
import '../../shared/service/clinical_repository.dart';

final patientsRepository = DemoClinicalRepository<Patient>([
  Patient.fromJson({
    "id": "demo-1",
    "active": true,
    "first_name": "Paciente de ejemplo",
    "patient_code": "PAC-DEMO-001",
    "last_name": "Demo",
    "birth_date": "1990-01-15",
    "sex": "Femenino",
    "phone": "",
    "email": "",
  }),
  Patient.fromJson({
    "id": "demo-2",
    "active": false,
    "first_name": "Segundo paciente",
    "patient_code": "PAC-DEMO-002",
    "last_name": "Demo",
    "birth_date": "1985-06-20",
    "sex": "Masculino",
    "phone": "",
    "email": "",
  }),
]);
