import 'package:flutter/material.dart' hide DateUtils;
import 'package:go_router/go_router.dart';

// Model
import '../model/permission.model.dart';
import '../model/role_detail_model.dart';
// Service
import '../service/roles_service.dart';

// Utils
import 'package:medimaya_app/shared/utils/date_utils.dart';
import 'package:medimaya_app/shared/utils/permissions.dart';
import 'package:medimaya_app/shared/utils/user_model.dart';
// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
// Widget
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';
import 'package:medimaya_app/shared/ui/widget/common/info_card.dart';
// Layouts
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class RolesShowPage extends StatefulWidget {
  final String id;

  const RolesShowPage({super.key, required this.id});

  @override
  State<RolesShowPage> createState() => _RolesShowPageState();
}

class _RolesShowPageState extends State<RolesShowPage> {
  final _service = RolesService();

  RoleDetail? _detail;
  List<PermissionGroup> _groups = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        _service.get(widget.id),
        _service.permissions(),
      ]);

      if (!mounted) return;

      setState(() {
        _detail = results[0] as RoleDetail;
        _groups = results[1] as List<PermissionGroup>;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);
    }
  }

  Future<void> _openEdit() async {
    final detail = _detail;
    if (detail == null) return;

    final changed = await context.push<bool>(
      '/dashboard/roles/${detail.id}/edit',
    );
    if (changed == true) _load();
  }

  List<MapEntry<PermissionGroup, List<Permission>>> get _groupedPermissions {
    final detail = _detail;
    if (detail == null) return const [];

    final selected = detail.permissions.toSet();

    return _groups
        .map(
          (group) => MapEntry(
            group,
            group.permissions
                .where((permission) => selected.contains(permission.id))
                .toList(),
          ),
        )
        .where((entry) => entry.value.isNotEmpty)
        .toList();
  }

  int get _totalPermissions =>
      _groups.fold(0, (sum, group) => sum + group.permissions.length);

  ({String label, Color color}) get _status {
    if (_detail?.deletedAt != null) {
      return (label: 'Eliminado', color: AppColors.error);
    }

    return _detail?.active == true
        ? (label: 'Activo', color: AppColors.exito)
        : (label: 'Inactivo', color: AppColors.error);
  }

  String _fullName(UserProfile? user) {
    final name = user?.fullName ?? '';
    return name.isEmpty ? '—' : name;
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Detalle de rol',
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _detail == null
          ? const SizedBox.shrink()
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final detail = _detail!;

    final stats = <Widget>[
      InfoCard(
        icon: Icons.group_outlined,
        label: 'Usuarios asignados',
        value: '${detail.usersCount}',
      ),
      InfoCard(
        icon: Icons.calendar_month_outlined,
        label: 'Creado',
        value: DateUtils.formatDate(detail.createdAt),
        subtitle: 'por ${_fullName(detail.createdBy)}',
      ),
      InfoCard(
        icon: Icons.edit_outlined,
        label: 'Actualizado',
        value: DateUtils.formatDate(detail.updatedAt),
        subtitle: 'por ${_fullName(detail.updatedBy)}',
      ),
      if (detail.deletedAt != null)
        InfoCard(
          icon: Icons.delete_outline,
          label: 'Eliminado',
          value: DateUtils.formatDate(detail.deletedAt),
          subtitle: 'por ${_fullName(detail.deletedBy)}',
          iconColor: AppColors.error,
          iconBg: AppColors.error.withValues(alpha: 0.15),
          containerColor: AppColors.error.withValues(alpha: 0.1),
          borderColor: AppColors.error.withValues(alpha: 0.35),
        ),
    ];

    final canUpdate = hasPermission('roles:update');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, box) {
            final title = Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Text(
                  detail.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.colorTexto,
                  ),
                ),
                AppBadge(label: _status.label, color: _status.color),
              ],
            );

            final editButton = SizedBox(
              height: 42,
              child: ElevatedButton.icon(
                onPressed: _openEdit,
                style: ButtonThemes.primary(),
                icon: const Icon(Icons.edit_outlined, size: 20),
                label: const Text(
                  'Editar rol',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            );

            if (box.maxWidth >= 480) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: title),
                  if (canUpdate) ...[const SizedBox(width: 16), editButton],
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                title,
                if (canUpdate) ...[const SizedBox(height: 12), editButton],
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        InfoCard(
          icon: Icons.description_outlined,
          label: 'Descripción',
          value: detail.description?.trim().isNotEmpty == true
              ? detail.description!
              : 'Sin descripción.',
          isValueBold: false,
          padding: const EdgeInsets.all(20),
        ),

        const SizedBox(height: 16),

        LayoutBuilder(
          builder: (context, box) {
            const gap = 16.0;
            final perRow = box.maxWidth >= 1080
                ? (detail.deletedAt != null ? 4 : 3)
                : box.maxWidth >= 620
                ? 2
                : 1;
            final rows = <List<Widget>>[];
            for (var i = 0; i < stats.length; i += perRow) {
              rows.add(
                stats.sublist(
                  i,
                  i + perRow > stats.length ? stats.length : i + perRow,
                ),
              );
            }

            return Column(
              children: [
                for (var r = 0; r < rows.length; r++) ...[
                  if (r > 0) const SizedBox(height: gap),
                  if (rows[r].length == 1)
                    rows[r].first
                  else
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var c = 0; c < rows[r].length; c++) ...[
                            if (c > 0) const SizedBox(width: gap),
                            Expanded(child: rows[r][c]),
                          ],
                        ],
                      ),
                    ),
                ],
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        Expanded(child: _buildPermissionsCard(detail)),
      ],
    );
  }

  Widget _buildPermissionsCard(RoleDetail detail) {
    final grouped = _groupedPermissions;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.colorFondo,
        border: Border.all(color: AppColors.colorOutlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Permisos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.colorTexto,
                  ),
                ),
                Text(
                  '${detail.permissions.length} / $_totalPermissions permisos',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.colorTextoSecundario,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: grouped.isEmpty
                  ? const Center(
                      child: Text(
                        'Este rol no tiene permisos asignados.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.colorTextoSecundario,
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        for (var i = 0; i < grouped.length; i++) ...[
                          if (i > 0)
                            const Divider(
                              height: 32,
                              thickness: 1,
                              color: AppColors.colorOutlineVariant,
                            ),
                          Padding(
                            padding: EdgeInsets.only(top: i == 0 ? 12 : 0),
                            child: Text(
                              grouped[i].key.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.colorTexto,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final permission in grouped[i].value)
                                _permissionChip(permission),
                            ],
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _permissionChip(Permission permission) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.colorPrimarioContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 15,
            color: AppColors.colorOnPrimarioContainer,
          ),
          const SizedBox(width: 6),
          Text(
            permission.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.colorOnPrimarioContainer,
            ),
          ),
        ],
      ),
    );
  }
}
