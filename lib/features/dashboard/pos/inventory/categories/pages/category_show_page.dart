import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:go_router/go_router.dart';

// Model
import '../model/category.model.dart';
// Service
import '../service/category_service.dart';

// Utils
import 'package:medimaya_app/shared/api/error/api_error.dart';
import 'package:medimaya_app/shared/utils/permissions.dart';
// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
// Widget
import 'package:medimaya_app/shared/ui/widget/common/app_audit_card.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/widget/common/info_card.dart';
// Layouts
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class CategoryShowPage extends StatefulWidget {
  const CategoryShowPage({super.key, required this.id});

  final String id;

  @override
  State<CategoryShowPage> createState() => _CategoryShowPageState();
}

class _CategoryShowPageState extends State<CategoryShowPage> {
  final _service = CategoryService();

  CategoryDetail? _category;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final category = await _service.get(widget.id);

      if (!mounted) return;

      setState(() {
        _category = category;
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

  Future<void> _openEdit() async {
    final changed = await context.push<bool>(
      '/dashboard/pos/inventory/categories/${widget.id}/edit',
    );
    if (changed == true) _load();
  }

  ({String label, Color color}) _status(CategoryDetail category) {
    if (!category.active) {
      return (label: 'Desactivada', color: AppColors.colorOutlineVariant);
    }

    return (label: 'Activa', color: AppColors.exito);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Detalle de categoría',
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
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
          : _buildContent(_category!),
    );
  }

  Widget _buildContent(CategoryDetail category) {
    final status = _status(category);
    final description = category.description?.trim() ?? '';

    return ListView(
      children: [
        LayoutBuilder(
          builder: (context, box) {
            final title = Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.colorTexto,
                  ),
                ),
                AppBadge(label: status.label, color: status.color),
              ],
            );

            if (!hasPermission('product-categories:update') ||
                !category.active) {
              return title;
            }

            final editButton = SizedBox(
              height: 42,
              child: ElevatedButton.icon(
                onPressed: _openEdit,
                style: ButtonThemes.primary(),
                icon: const Icon(Icons.edit_outlined, size: 20),
                label: const Text(
                  'Editar',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            );

            if (box.maxWidth >= 480) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: title),
                  const SizedBox(width: 16),
                  editButton,
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [title, const SizedBox(height: 12), editButton],
            );
          },
        ),

        const SizedBox(height: 16),

        InfoCard(
          icon: Icons.description_outlined,
          label: 'Descripción',
          value: description.isEmpty ? 'Sin descripción.' : description,
          isValueBold: false,
          padding: const EdgeInsets.all(20),
        ),

        const SizedBox(height: 16),

        InfoCard(
          icon: Icons.inventory_2_outlined,
          label: 'Productos asignados',
          value: '${category.productsCount}',
        ),

        if (category.hasAudit) ...[
          const SizedBox(height: 16),

          AppAuditCard(
            createdAt: category.createdAt,
            createdBy: category.createdBy?.fullName,
            updatedAt: category.updatedAt,
            updatedBy: category.updatedBy?.fullName,
            deletedAt: category.deletedAt,
            deletedBy: category.deletedBy?.fullName,
          ),
        ],
      ],
    );
  }
}
