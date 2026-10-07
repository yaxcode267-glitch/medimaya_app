import 'package:go_router/go_router.dart';

import 'consultation_field_list_page.dart';
import 'consultation_field_form_page.dart';
import 'consultation_field_show_page.dart';

import 'package:medimaya_app/shared/utils/permissions.dart';

final List<GoRoute> consultationFieldRoutes = [
  GoRoute(
    path: '/dashboard/consultation-fields',
    redirect: (context, state) =>
        hasPermission('consultation-fields:view') ? null : '/dashboard',
    builder: (context, state) => const ConsultationFieldListPage(),
    routes: [
      GoRoute(
        path: 'create',
        redirect: (context, state) =>
            hasPermission('consultation-fields:create')
            ? null
            : '/dashboard/consultation-fields',
        builder: (context, state) => const ConsultationFieldFormPage(),
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) =>
            ConsultationFieldShowPage(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: ':id/edit',
        redirect: (context, state) =>
            hasPermission('consultation-fields:update')
            ? null
            : '/dashboard/consultation-fields',
        builder: (context, state) =>
            ConsultationFieldFormPage(id: state.pathParameters['id']),
      ),
    ],
  ),
];
