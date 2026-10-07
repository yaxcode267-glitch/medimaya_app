import 'package:go_router/go_router.dart';

import 'document_type_list_page.dart';
import 'document_type_form_page.dart';
import 'document_type_show_page.dart';

import 'package:medimaya_app/shared/utils/permissions.dart';

final List<GoRoute> documentTypeRoutes = [
  GoRoute(
    path: '/dashboard/document-types',
    redirect: (context, state) =>
        hasPermission('document-types:view') ? null : '/dashboard',
    builder: (context, state) => const DocumentTypeListPage(),
    routes: [
      GoRoute(
        path: 'create',
        redirect: (context, state) => hasPermission('document-types:create')
            ? null
            : '/dashboard/document-types',
        builder: (context, state) => const DocumentTypeFormPage(),
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) =>
            DocumentTypeShowPage(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: ':id/edit',
        redirect: (context, state) => hasPermission('document-types:update')
            ? null
            : '/dashboard/document-types',
        builder: (context, state) =>
            DocumentTypeFormPage(id: state.pathParameters['id']),
      ),
    ],
  ),
];
