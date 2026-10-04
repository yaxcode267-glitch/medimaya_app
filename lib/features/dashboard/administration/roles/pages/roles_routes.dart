import 'package:go_router/go_router.dart';

// Pages
import 'roles_create_page.dart';
import 'roles_edit_page.dart';
import 'roles_list_page.dart';
import 'roles_show_page.dart';

final List<GoRoute> rolesRoutes = [
  GoRoute(
    path: '/dashboard/roles',
    name: 'Roles',
    builder: (context, state) => const RolesListPage(),
  ),
  GoRoute(
    path: '/dashboard/roles/create',
    builder: (context, state) => const RolesCreatePage(),
  ),
  GoRoute(
    path: '/dashboard/roles/:id',
    builder: (context, state) =>
        RolesShowPage(id: state.pathParameters['id'] ?? ''),
  ),
  GoRoute(
    path: '/dashboard/roles/:id/edit',
    builder: (context, state) =>
        RolesEditPage(id: state.pathParameters['id'] ?? ''),
  ),
];
