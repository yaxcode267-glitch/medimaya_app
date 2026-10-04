import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Models
import '../model/role.model.dart';
// Service
import '../service/roles_service.dart';

// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
// Widget
import 'package:medimaya_app/shared/ui/widget/common/app_alert.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
import 'package:medimaya_app/shared/ui/widget/common/data_table.dart';
import 'package:medimaya_app/shared/ui/widget/common/filter_tabs.dart';
import 'package:medimaya_app/shared/ui/widget/common/confirm_toggle.dart';

// Layout
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class RolesListPage extends StatefulWidget {
  const RolesListPage({super.key});

  @override
  State<RolesListPage> createState() => _RolesListPageState();
}

class _RolesListPageState extends State<RolesListPage> {
  final _service = RolesService();
  final _search = TextEditingController();

  List<Role> _roles = [];
  String _filter = 'all';
  bool _loading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    try {
      final roles = await _service.list(
        active: _filter,
        search: _search.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _roles = roles;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _searchRoles(String _) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), _load);
  }

  Future<void> _toggle(Role role) async {
    try {
      final done = await confirmToggleState(
        context: context,
        active: role.active,
        itemName: role.name,
        itemLabel: 'rol',
        wasDeleted: role.deleted,
        onActivate: () => _service.activate(role.id),
        onDeactivate: () => _service.deactivate(role.id),
      );

      if (done) {
        AppAlert.success(
          role.deleted
              ? 'Rol "${role.name}" restaurado'
              : 'Rol "${role.name}" ${role.active ? 'desactivado' : 'activado'}',
        );
        _load();
      }
    } on DioException {
      // El interceptor muestra el error.
    }
  }

  Future<void> _openForm(String path) async {
    final result = await context.push<bool>(path);
    if (result == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Roles',
      fab: FloatingActionButton.extended(
        onPressed: () => _openForm('/dashboard/roles/create'),
        icon: const Icon(Icons.add),
        label: const Text('Crear rol'),
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (_, box) {
              final search = AppInput(
                name: 'Buscador',
                hint: 'Buscar por nombre o descripción',
                controller: _search,
                onChanged: _searchRoles,
                prefixIcon: const Icon(Icons.search, size: 20),
              );

              final filters = AppFilterTabs(
                filter: _filter,
                options: const [
                  FilterOption(value: 'all', label: 'Todos'),
                  FilterOption(value: 'active', label: 'Activos'),
                  FilterOption(value: 'inactive', label: 'Inactivos'),
                ],
                onChanged: (value) {
                  setState(() => _filter = value);
                  _load();
                },
              );

              return box.maxWidth >= 720
                  ? Row(
                      children: [
                        Expanded(child: search),
                        const SizedBox(width: 16),
                        SizedBox(width: 360, child: filters),
                      ],
                    )
                  : Column(
                      children: [search, const SizedBox(height: 12), filters],
                    );
            },
          ),

          const SizedBox(height: 16),
          Expanded(
            child: AppDataTable(
              columns: const [
                TableColumn(key: 'name', label: 'Nombre'),
                TableColumn(key: 'description', label: 'Descripción'),
                TableColumn(
                  key: 'state',
                  label: 'Estado',
                  align: TextAlign.center,
                ),
                TableColumn(
                  key: 'actions',
                  label: 'Acciones',
                  align: TextAlign.center,
                ),
              ],
              loading: _loading,
              reload: _load,
              rows: _roles.map((role) {
                return {
                  'name': Text(
                    role.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  'description': Text(
                    role.description?.trim().isNotEmpty == true
                        ? role.description!
                        : '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  'state': AppBadge(
                    label: role.deleted
                        ? 'Eliminado'
                        : role.active
                        ? 'Activo'
                        : 'Inactivo',
                    color: role.deleted
                        ? AppColors.error
                        : role.active
                        ? AppColors.exito
                        : AppColors.colorOutlineVariant,
                  ),
                  'actions': Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Ver',
                        onPressed: () =>
                            context.push('/dashboard/roles/${role.id}'),
                        icon: const Icon(Icons.visibility_outlined, size: 20),
                      ),
                      if (!role.deleted)
                        IconButton(
                          tooltip: 'Editar',
                          onPressed: () =>
                              _openForm('/dashboard/roles/${role.id}/edit'),
                          icon: const Icon(Icons.edit_outlined, size: 20),
                        ),
                      IconButton(
                        tooltip: role.deleted
                            ? 'Restaurar'
                            : role.active
                            ? 'Desactivar'
                            : 'Activar',
                        onPressed: () => _toggle(role),
                        icon: Icon(
                          role.active
                              ? Icons.block
                              : Icons.check_circle_outline,
                          size: 20,
                          color: role.active
                              ? AppColors.error
                              : AppColors.exito,
                        ),
                      ),
                    ],
                  ),
                };
              }).toList(),
              emptyText: _filter != 'all' || _search.text.isNotEmpty
                  ? 'No hay roles que coincidan'
                  : 'Aún no hay roles.',
            ),
          ),
        ],
      ),
    );
  }
}
