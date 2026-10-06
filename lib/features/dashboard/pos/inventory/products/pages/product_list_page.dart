import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Models
import '../model/product.model.dart';
// Service
import '../service/product_service.dart';
// Widget
import '../widget/category_field.dart';
import '../widget/product_thumb.dart';

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

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _service = ProductService();
  final _search = TextEditingController();

  List<Product> _products = [];
  String _filter = 'all';
  String? _categoryId = CategoryField.none;
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
      final products = await _service.list(
        active: _filter,
        search: _search.text.trim(),
        categoryId: _categoryId == null || _categoryId == CategoryField.none
            ? null
            : _categoryId,
      );

      if (!mounted) return;

      setState(() {
        _products = products;
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

  void _searchProducts(String _) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), _load);
  }

  Future<void> _toggle(Product product) async {
    try {
      final changed = await confirmToggleState(
        context: context,
        active: product.active,
        itemName: product.name,
        itemLabel: 'producto',
        wasDeleted: product.deleted,
        onActivate: () => _service.activate(product.id),
        onDeactivate: () => _service.deactivate(product.id),
      );

      if (changed) _load();
    } on DioException {
      // El interceptor muestra el error.
    }
  }

  Future<void> _openForm(String path) async {
    final result = await context.push<bool>(path);
    if (result == true) _load();
  }

  Map<String, dynamic> _row(Product product) => {
    'image': ProductThumb(url: product.imageUrl),
    'name': Text(
      product.name,
      style: const TextStyle(fontWeight: FontWeight.w600),
    ),
    'category': Text(
      product.categoryName ?? '—',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    'price': Text('S/ ${product.price.toStringAsFixed(2)}'),
    'state': AppBadge(
      label: product.active ? 'Activo' : 'Desactivado',
      color: product.active ? AppColors.exito : AppColors.colorOutlineVariant,
    ),
    'actions': _actions(product),
  };

  Widget _actions(Product product) {
    final canUpdate = hasPermission('products:update');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Ver',
          onPressed: () =>
              context.push('/dashboard/pos/inventory/products/${product.id}'),
          icon: const Icon(Icons.visibility_outlined, size: 20),
        ),
        if (canUpdate && !product.deleted)
          IconButton(
            tooltip: 'Editar',
            onPressed: () => _openForm(
              '/dashboard/pos/inventory/products/${product.id}/edit',
            ),
            icon: const Icon(Icons.edit_outlined, size: 20),
          ),
        if (canUpdate)
          IconButton(
            tooltip: product.active ? 'Desactivar' : 'Activar',
            onPressed: () => _toggle(product),
            icon: Icon(
              product.active ? Icons.block : Icons.check_circle_outline,
              size: 20,
              color: product.active ? AppColors.error : AppColors.exito,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = hasPermission('products:create');

    return DashboardLayout(
      title: 'Productos',
      fab: canCreate
          ? FloatingActionButton.extended(
              onPressed: () =>
                  _openForm('/dashboard/pos/inventory/products/create'),
              icon: const Icon(Icons.add),
              label: const Text('Crear producto'),
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
                onChanged: _searchProducts,
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

              final category = CategoryField(
                value: _categoryId ?? CategoryField.none,
                onChanged: (value) {
                  setState(() => _categoryId = value);
                  _load();
                },
                includeAll: true,
                onlyActive: false,
                name: 'Categoría',
              );

              return box.maxWidth >= 960
                  ? Row(
                      children: [
                        Expanded(flex: 3, child: search),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: category),
                        const SizedBox(width: 16),
                        SizedBox(width: 280, child: filters),
                      ],
                    )
                  : Column(
                      children: [
                        search,
                        const SizedBox(height: 12),
                        category,
                        const SizedBox(height: 12),
                        filters,
                      ],
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
                      TableColumn(
                        key: 'image',
                        label: 'Imagen',
                        align: TextAlign.center,
                      ),
                      TableColumn(key: 'name', label: 'Nombre'),
                      TableColumn(key: 'category', label: 'Categoría'),
                      TableColumn(
                        key: 'price',
                        label: 'Precio',
                        align: TextAlign.right,
                      ),
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
                    rows: _products.map(_row).toList(),
                    emptyText:
                        _filter != 'all' ||
                            _search.text.isNotEmpty ||
                            (_categoryId != null &&
                                _categoryId != CategoryField.none)
                        ? 'No hay productos que coincidan'
                        : 'Aún no hay productos.',
                    emptyIcon: Icons.inventory_2_outlined,
                  ),
          ),
        ],
      ),
    );
  }
}
