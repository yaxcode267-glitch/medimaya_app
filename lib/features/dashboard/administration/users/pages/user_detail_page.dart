import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medimaya_app/features/dashboard/profile/store/profile_controller.dart';
import 'package:medimaya_app/shared/api/error/api_error.dart';
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_audit_card.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_card.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_user_avatar.dart';

import '../model/user_model.dart';
import '../store/user_store.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key, required this.id});
  final String id;
  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final store = UserStore.instance;
  UserDetail? user;
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final result = await store.detail(widget.id);
      if (mounted) setState(() => user = result);
    } on DioException catch (e) {
      if (mounted) setState(() => error = ApiError.fromDio(e).message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = user;
    final profile = ProfileController.instance;
    return DashboardLayout(
      title: 'Detalle del usuario',
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: AppEmptyState(icon: Icons.error_outline, message: error!),
            )
          : current == null
          ? const AppEmptyState(message: 'No se encontró el usuario.')
          : LayoutBuilder(
              builder: (context, box) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _UserHeader(
                      user: current,
                      edit: profile.hasPermission('users:update')
                          ? FilledButton.icon(
                              style: ButtonThemes.primary(),
                              onPressed: () => context.go(
                                '/dashboard/users/${widget.id}/edit',
                              ),
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              label: const Text('Editar usuario'),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    if (current.hasAudit)
                      AppAuditCard(
                        createdAt: current.createdAt,
                        createdBy: current.createdBy,
                        updatedAt: current.updatedAt,
                        updatedBy: current.updatedBy,
                        deletedAt: current.deletedAt,
                        deletedBy: current.deletedBy,
                      ),
                    const SizedBox(height: 16),
                    _PermissionsCard(
                      user: current,
                      height: box.maxHeight * 0.6,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader({required this.user, this.edit});
  final UserDetail user;
  final Widget? edit;

  @override
  Widget build(BuildContext context) => AppCard(
    child: LayoutBuilder(
      builder: (context, box) {
        final identity = Row(
          children: [
            AppUserAvatar(imageUrl: user.profile, radius: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.colorTexto,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppBadge(
                        label: user.roleName ?? 'Sin rol',
                        color: AppColors.colorPrimarioContainer,
                      ),
                      AppBadge(
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (box.maxWidth >= 560)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: identity),
                  if (edit != null) ...[const SizedBox(width: 16), edit!],
                ],
              )
            else ...[
              identity,
              if (edit != null) ...[const SizedBox(height: 16), edit!],
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.alternate_email,
                  size: 20,
                  color: AppColors.colorPrimario,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Correo electrónico',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorTextoSecundario,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}

class _PermissionsCard extends StatefulWidget {
  const _PermissionsCard({required this.user, required this.height});
  final UserDetail user;
  final double height;

  @override
  State<_PermissionsCard> createState() => _PermissionsCardState();
}

class _PermissionsCardState extends State<_PermissionsCard> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppCard(
    child: SizedBox(
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                'Permisos del rol',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${widget.user.permissions.fold<int>(0, (sum, group) => sum + group.items.length)} permisos',
                style: const TextStyle(color: AppColors.colorTextoSecundario),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: widget.user.permissions.isEmpty
                ? const Center(
                    child: AppEmptyState(
                      message: 'Este rol no tiene permisos asignados.',
                    ),
                  )
                : Scrollbar(
                    controller: controller,
                    thumbVisibility: true,
                    child: ListView.separated(
                      controller: controller,
                      padding: const EdgeInsets.only(right: 12),
                      itemCount: widget.user.permissions.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 32,
                        color: AppColors.colorOutlineVariant,
                      ),
                      itemBuilder: (context, index) {
                        final group = widget.user.permissions[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final permission in group.items)
                                  AppBadge(
                                    label: permission,
                                    color: AppColors.colorPrimarioContainer,
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}
