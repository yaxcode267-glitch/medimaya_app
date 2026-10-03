import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medimaya_app/features/dashboard/profile/store/profile_controller.dart';
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_user_avatar.dart';
import 'package:medimaya_app/shared/ui/widget/common/confirm_dialog.dart';
import 'package:medimaya_app/shared/ui/widget/common/data_table.dart';
import 'package:medimaya_app/shared/ui/widget/common/filter_tabs.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';

import '../model/user_model.dart';
import '../store/user_store.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final store = UserStore.instance;
  late final search = TextEditingController(text: store.search);

  @override
  void initState() {
    super.initState();
    store.load();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void searchUsers() {
    store.search = search.text;
    store.load();
  }

  Widget _statusBadge(UserSummary user) => AppBadge(
    label: user.deletedAt != null
        ? 'Eliminado'
        : user.active
        ? 'Activo'
        : 'Inactivo',
    color: user.deletedAt != null
        ? AppColors.error
        : user.active
        ? AppColors.exito
        : AppColors.colorSuperficie,
  );

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title: 'Usuarios',
    fab: ProfileController.instance.hasPermission('users:create')
        ? FloatingActionButton.extended(
            onPressed: () => context.go('/dashboard/users/new'),
            icon: const Icon(Icons.add),
            label: const Text('Nuevo usuario'),
          )
        : null,
    child: AnimatedBuilder(
      animation: store,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, box) {
              final field = AppInput(
                name: 'Buscador',
                hint: 'Buscar por nombre o correo',
                controller: search,
                prefixIcon: const Icon(Icons.search, size: 20),
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (_) => searchUsers(),
                suffixIcon: IconButton(
                  tooltip: 'Buscar usuarios',
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: searchUsers,
                ),
              );
              final filters = AppFilterTabs(
                filter: store.active,
                options: const [
                  FilterOption(value: 'all', label: 'Todos'),
                  FilterOption(value: 'true', label: 'Activos'),
                  FilterOption(value: 'false', label: 'Inactivos'),
                ],
                onChanged: (value) {
                  store.active = value;
                  store.load();
                },
              );
              return box.maxWidth >= 720
                  ? Row(
                      children: [
                        Expanded(flex: 3, child: field),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: filters),
                      ],
                    )
                  : Column(
                      children: [field, const SizedBox(height: 12), filters],
                    );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: store.error != null && !store.loading
                ? Center(
                    child: AppEmptyState(
                      icon: Icons.error_outline,
                      message: store.error!,
                      action: TextButton.icon(
                        onPressed: store.load,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Recargar'),
                      ),
                    ),
                  )
                : AppDataTable(
                    loading: store.loading,
                    reload: store.load,
                    emptyIcon: Icons.people_outline,
                    emptyText: 'No se encontraron usuarios con estos filtros.',
                    columns: const [
                      TableColumn(key: 'name', label: 'Usuario'),
                      TableColumn(key: 'email', label: 'Correo'),
                      TableColumn(key: 'role', label: 'Rol'),
                      TableColumn(key: 'status', label: 'Estado'),
                      TableColumn(key: 'actions', label: 'Acciones'),
                    ],
                    rows: [
                      for (final user in store.users)
                        {
                          'name': Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppUserAvatar(imageUrl: user.profile),
                              const SizedBox(width: 12),
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          'email': user.email,
                          'role': user.roleName ?? 'Sin rol',
                          'status': _statusBadge(user),
                          'actions': _UserRowActions(
                            key: ValueKey(user.id),
                            user: user,
                          ),
                        },
                    ],
                  ),
          ),
        ],
      ),
    ),
  );
}

class _UserRowActions extends StatefulWidget {
  const _UserRowActions({super.key, required this.user});
  final UserSummary user;
  @override
  State<_UserRowActions> createState() => _UserRowActionsState();
}

class _UserRowActionsState extends State<_UserRowActions> {
  bool pending = false;

  Future<void> _confirm({required bool reset}) async {
    final store = UserStore.instance;
    if (pending || store.saving) return;
    final user = widget.user;
    final activate = !user.active || user.deletedAt != null;
    setState(() => pending = true);
    try {
      final confirmed = await AppConfirm.show(
        context: context,
        title: reset
            ? 'Restablecer contraseña'
            : activate
            ? 'Activar usuario'
            : 'Eliminar usuario',
        message: reset
            ? 'Se cambiará la contraseña de ${user.fullName} y se enviará una nueva a ${user.email}.'
            : activate
            ? '¿Deseas activar a ${user.fullName}? Si estaba eliminado, se restaurará su registro.'
            : '¿Deseas eliminar a ${user.fullName}? Se desactivará su acceso y el registro podrá restaurarse al activarlo.',
        confirmText: reset
            ? 'Restablecer'
            : activate
            ? 'Activar'
            : 'Eliminar',
        tone: !reset && !activate ? ConfirmTone.danger : ConfirmTone.warning,
      );
      if (confirmed != true || !mounted) return;
      if (reset) {
        await store.resetPassword(user.id);
      } else {
        await store.setActive(user.id, activate);
      }
    } finally {
      if (mounted) setState(() => pending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final profile = ProfileController.instance;
    final activate = !user.active || user.deletedAt != null;
    return AnimatedBuilder(
      animation: UserStore.instance,
      builder: (context, _) {
        final disabled = pending || UserStore.instance.saving;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Ver detalle',
              icon: const Icon(Icons.visibility_outlined),
              onPressed: disabled
                  ? null
                  : () => context.go('/dashboard/users/${user.id}'),
            ),
            if (profile.hasPermission('users:update')) ...[
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit_outlined),
                onPressed: disabled
                    ? null
                    : () => context.go('/dashboard/users/${user.id}/edit'),
              ),
              IconButton(
                tooltip: 'Restablecer contraseña',
                icon: const Icon(Icons.key_outlined),
                onPressed: disabled ? null : () => _confirm(reset: true),
              ),
              IconButton(
                tooltip: activate ? 'Activar usuario' : 'Eliminar usuario',
                icon: Icon(
                  activate ? Icons.check_circle_outline : Icons.delete_outline,
                ),
                style: IconButton.styleFrom(
                  foregroundColor: activate ? AppColors.exito : AppColors.error,
                ),
                onPressed:
                    disabled || (!activate && user.id == profile.user?.id)
                    ? null
                    : () => _confirm(reset: false),
              ),
            ],
          ],
        );
      },
    );
  }
}
