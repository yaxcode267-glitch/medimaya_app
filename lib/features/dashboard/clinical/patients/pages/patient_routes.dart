import 'package:go_router/go_router.dart';

import 'patient_list_page.dart';
import 'patient_form_page.dart';
import 'patient_show_page.dart';

import 'package:medimaya_app/shared/utils/permissions.dart';

final List<GoRoute> patientRoutes = [
  GoRoute(
    path: '/dashboard/patients',
    redirect: (context, state) =>
        hasPermission('patients:view') ? null : '/dashboard',
    builder: (context, state) => const PatientListPage(),
    routes: [
      GoRoute(
        path: 'create',
        redirect: (context, state) => '/dashboard/consultations/create',
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) =>
            PatientShowPage(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: ':id/edit',
        redirect: (context, state) =>
            hasPermission('patients:update') ? null : '/dashboard/patients',
        builder: (context, state) =>
            PatientFormPage(id: state.pathParameters['id'] ?? ''),
      ),
    ],
  ),
];
