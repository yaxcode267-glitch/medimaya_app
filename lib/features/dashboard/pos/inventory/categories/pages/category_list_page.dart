import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Models
import '../model/category.model.dart';
// Service
import '../service/category_service.dart';

// Utils
import 'package:medimaya_app/shared/api/error/api_error.dart';
import 'package:medimaya_app/shared/utils/permissions.dart';
// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
// Widget
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/widget/common/confirm_toggle.dart';
import 'package:medimaya_app/shared/ui/widget/common/data_table.dart';
import 'package:medimaya_app/shared/ui/widget/common/filter_tabs.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
// Layouts
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final _service = CategoryService();
  final _search = TextEditingController();

  List<Category> _categories = [];
  String _filter = 'all';
  String? _error;
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
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final categories = await _service.list(
        active: _filter,
        search: _search.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;

      setState(() {
        _error = ApiError.fromDio(e).message;
        _loading = false;
      });
    }
  }

  void _searchCategories(String _) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), _load);
  }

  Future<void> _toggle(Category category) async {
    try {
      final changed = await confirmToggleState(
        context: context,
        active: category.active,
        itemName: category.name,
        itemLabel: 'categoría',
        wasDeleted: category.deleted,
        onActivate: () => _service.activate(category.id),
        onDeactivate: () => _service.deactivate(category.id),
      );

      if (changed) _load();
    } on DioException {
      // El interceptor muestra el error, por ejemplo cuando la categoría tiene
      // productos activos y no se puede desactivar.
    }
  }

  Future<void> _openForm(String path) async {
    final result = await context.push<bool>(path);
    if (result == true) _load();
  }

  Map<String, dynamic> _row(Category category) => {
    'name': Text(
      category.name,
      style: const TextStyle(fontWeight: FontWeight.w600),
    ),
    'description': Text(
      category.descriptionText.isEmpty ? '—' : category.descriptionText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    'state': AppBadge(
      label: category.active ? 'Activa' : 'Desactivada',
      color: category.active ? AppColors.exito : AppColors.colorOutlineVariant,
    ),
    'actions': _actions(category),
  };

  Widget _actions(Category category) {
    final canUpdate = hasPermission('product-categories:update');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Ver',
          onPressed: () => context.push(
            '/dashboard/pos/inventory/categories/${category.id}',
          ),
          icon: const Icon(Icons.visibility_outlined, size: 20),
        ),
        if (canUpdate && !category.deleted)
          IconButton(
            tooltip: 'Editar',
            onPressed: () => _openForm(
              '/dashboard/pos/inventory/categories/${category.id}/edit',
            ),
            icon: const Icon(Icons.edit_outlined, size: 20),
          ),
        if (canUpdate)
          IconButton(
            tooltip: category.active ? 'Desactivar' : 'Activar',
            onPressed: () => _toggle(category),
            icon: Icon(
              category.active ? Icons.block : Icons.check_circle_outline,
              size: 20,
              color: category.active ? AppColors.error : AppColors.exito,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = hasPermission('product-categories:create');

    return DashboardLayout(
      title: 'Categorías',
      fab: canCreate
          ? FloatingActionButton.extended(
              onPressed: () =>
                  _openForm('/dashboard/pos/inventory/categories/create'),
              icon: const Icon(Icons.add),
              label: const Text('Crear categoría'),
            )
          : null,
      child: Column(
        children: [
          LayoutBuilder(
            builder: (_, box) {
              final search = AppInput(
                name: 'Buscador',
                hint: 'Buscar por nombre',
                controller: _search,
                onChanged: _searchCategories,
                prefixIcon: const Icon(Icons.search, size: 20),
              );

              final filters = AppFilterTabs(
                filter: _filter,
                options: const [
                  FilterOption(value: 'all', label: 'Todas'),
                  FilterOption(value: 'active', label: 'Activas'),
                  FilterOption(value: 'inactive', label: 'Inactivas'),
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
            child: _error != null
                ? Center(
                    child: AppEmptyState(
                      icon: Icons.error_outline,
                      message: _error!,
                      action: OutlinedButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Reintentar'),
                      ),
                    ),
                  )
                : AppDataTable(
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
                    rows: _categories.map(_row).toList(),
                    emptyText: _filter != 'all' || _search.text.isNotEmpty
                        ? 'No hay categorías que coincidan'
                        : 'Aún no hay categorías.',
                    emptyIcon: Icons.category_outlined,
                  ),
          ),
        ],
      ),
    );
  }
}
