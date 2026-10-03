import 'package:go_router/go_router.dart';

import 'patient_portal_page.dart';

final List<GoRoute> patientRoutes = [
  GoRoute(
    path: '/paciente',
    name: 'Portal de paciente',
    builder: (context, state) => const PatientPortalPage(),
  ),
];
