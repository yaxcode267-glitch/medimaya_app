import 'package:go_router/go_router.dart';

import 'consultation_form_list_page.dart';
import 'consultation_form_form_page.dart';
import 'consultation_form_show_page.dart';

import 'package:medimaya_app/shared/utils/permissions.dart';

final List<GoRoute> consultationFormRoutes = [
  GoRoute(
    path: '/dashboard/consultation-forms',
    redirect: (context, state) =>
        hasPermission('consultation-forms:view') ? null : '/dashboard',
    builder: (context, state) => const ConsultationFormListPage(),
    routes: [
      GoRoute(
        path: 'create',
        redirect: (context, state) => hasPermission('consultation-forms:create')
            ? null
            : '/dashboard/consultation-forms',
        builder: (context, state) => const ConsultationFormFormPage(),
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) =>
            ConsultationFormShowPage(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: ':id/edit',
        redirect: (context, state) => hasPermission('consultation-forms:update')
            ? null
            : '/dashboard/consultation-forms',
        builder: (context, state) =>
            ConsultationFormFormPage(id: state.pathParameters['id']),
      ),
    ],
  ),
];
