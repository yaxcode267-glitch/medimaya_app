import 'package:go_router/go_router.dart';

import 'specialty_list_page.dart';
import 'specialty_form_page.dart';
import 'specialty_show_page.dart';

import 'package:medimaya_app/shared/utils/permissions.dart';

final List<GoRoute> specialtyRoutes = [
  GoRoute(
    path: '/dashboard/specialties',
    redirect: (context, state) =>
        hasPermission('specialties:view') ? null : '/dashboard',
    builder: (context, state) => const SpecialtyListPage(),
    routes: [
      GoRoute(
        path: 'create',
        redirect: (context, state) => hasPermission('specialties:create')
            ? null
            : '/dashboard/specialties',
        builder: (context, state) => const SpecialtyFormPage(),
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) =>
            SpecialtyShowPage(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: ':id/edit',
        redirect: (context, state) => hasPermission('specialties:update')
            ? null
            : '/dashboard/specialties',
        builder: (context, state) =>
            SpecialtyFormPage(id: state.pathParameters['id']),
      ),
    ],
  ),
];
