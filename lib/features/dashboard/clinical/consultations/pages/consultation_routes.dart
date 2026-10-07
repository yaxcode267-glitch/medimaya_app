import 'package:go_router/go_router.dart';

import 'consultation_list_page.dart';
import 'consultation_form_page.dart';
import 'consultation_show_page.dart';

import 'package:medimaya_app/shared/utils/permissions.dart';

final List<GoRoute> consultationRoutes = [
  GoRoute(
    path: '/dashboard/consultations',
    redirect: (context, state) =>
        hasPermission('consultations:view') ? null : '/dashboard',
    builder: (context, state) => const ConsultationListPage(),
    routes: [
      GoRoute(
        path: 'create',
        redirect: (context, state) => hasPermission('consultations:create')
            ? null
            : '/dashboard/consultations',
        builder: (context, state) => const ConsultationFormPage(),
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) =>
            ConsultationShowPage(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: ':id/edit',
        redirect: (context, state) => hasPermission('consultations:update')
            ? null
            : '/dashboard/consultations',
        builder: (context, state) =>
            ConsultationFormPage(id: state.pathParameters['id']),
      ),
    ],
  ),
];
