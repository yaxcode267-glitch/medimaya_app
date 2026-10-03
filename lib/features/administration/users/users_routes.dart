import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medimaya_app/features/dashboard/profile/store/profile_controller.dart';
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';

import 'pages/users_page.dart';
import 'pages/user_form_page.dart';
import 'pages/user_detail_page.dart';

final List<GoRoute> usersRoutes = [
  GoRoute(
    path: '/dashboard/users',
    builder: (_, _) =>
        const _UserAccess(permission: 'users:view', child: UsersPage()),
  ),
  GoRoute(
    path: '/dashboard/users/new',
    builder: (_, _) =>
        const _UserAccess(permission: 'users:create', child: UserFormPage()),
  ),
  GoRoute(
    path: '/dashboard/users/:id/edit',
    builder: (_, state) => _UserAccess(
      permission: 'users:update',
      child: UserFormPage(
        key: ValueKey(state.pathParameters['id']),
        id: state.pathParameters['id']!,
      ),
    ),
  ),
  GoRoute(
    path: '/dashboard/users/:id',
    builder: (_, state) => _UserAccess(
      permission: 'users:view',
      child: UserDetailPage(
        key: ValueKey(state.pathParameters['id']),
        id: state.pathParameters['id']!,
      ),
    ),
  ),
];

class _UserAccess extends StatelessWidget {
  const _UserAccess({required this.permission, required this.child});
  final String permission;
  final Widget child;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ProfileController.instance,
    builder: (_, _) =>
        ProfileController.instance.hasPermission(permission) &&
            ProfileController.instance.hasPermission('users:view')
        ? child
        : const DashboardLayout(
            title: 'Usuarios',
            child: Center(
              child: AppEmptyState(
                icon: Icons.lock_outline,
                message: 'No tienes permiso para acceder a esta sección.',
              ),
            ),
          ),
  );
}
