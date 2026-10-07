import 'package:go_router/go_router.dart';

import 'patients/pages/patient_routes.dart';
import 'consultations/pages/consultation_routes.dart';
import 'consultation_forms/pages/consultation_form_routes.dart';
import 'consultation_fields/pages/consultation_field_routes.dart';
import 'specialties/pages/specialty_routes.dart';
import 'document_types/pages/document_type_routes.dart';

final List<GoRoute> clinicalRoutes = [
  ...patientRoutes,
  ...consultationRoutes,
  ...consultationFormRoutes,
  ...consultationFieldRoutes,
  ...specialtyRoutes,
  ...documentTypeRoutes,
];
