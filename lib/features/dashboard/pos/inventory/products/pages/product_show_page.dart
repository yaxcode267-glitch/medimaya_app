import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Model
import '../model/product.model.dart';
// Service
import '../service/product_service.dart';

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

class ProductShowPage extends StatefulWidget {
  const ProductShowPage({super.key, required this.id});

  final String id;

  @override
  State<ProductShowPage> createState() => _ProductShowPageState();
}

class _ProductShowPageState extends State<ProductShowPage> {
  final _service = ProductService();

  ProductDetail? _product;
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
      final product = await _service.get(widget.id);

      if (!mounted) return;

      setState(() {
        _product = product;
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
      '/dashboard/pos/inventory/products/${widget.id}/edit',
    );
    if (changed == true) _load();
  }

  ({String label, Color color}) _status(ProductDetail product) {
    if (!product.active) {
      return (label: 'Desactivado', color: AppColors.colorOutlineVariant);
    }

    return (label: 'Activo', color: AppColors.exito);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Detalle de producto',
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
          : _buildContent(_product!),
    );
  }

  Widget _buildContent(ProductDetail product) {
    final status = _status(product);
    final description = product.description?.trim() ?? '';
    final price = product.price.toStringAsFixed(2);

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
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.colorTexto,
                  ),
                ),
                AppBadge(label: status.label, color: status.color),
              ],
            );

            if (!hasPermission('products:update') || !product.active) {
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

        if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
          _ImagePreview(url: product.imageUrl!),

        if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
          const SizedBox(height: 16),

        InfoCard(
          icon: Icons.attach_money_rounded,
          label: 'Precio',
          value: 'S/ $price',
        ),

        const SizedBox(height: 16),

        InfoCard(
          icon: Icons.category_outlined,
          label: 'Categoría',
          value: product.category?.name ?? 'Sin categoría',
        ),

        const SizedBox(height: 16),

        InfoCard(
          icon: Icons.description_outlined,
          label: 'Descripción',
          value: description.isEmpty ? 'Sin descripción.' : description,
          isValueBold: false,
          padding: const EdgeInsets.all(20),
        ),

        if (product.hasAudit) ...[
          const SizedBox(height: 16),

          AppAuditCard(
            createdAt: product.createdAt,
            createdBy: product.createdBy?.fullName,
            updatedAt: product.updatedAt,
            updatedBy: product.updatedBy?.fullName,
            deletedAt: product.deletedAt,
            deletedBy: product.deletedBy?.fullName,
          ),
        ],
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String url;

  const _ImagePreview({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorOutlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const ColoredBox(
            color: AppColors.colorSuperficie,
            child: Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 32,
                color: AppColors.colorTextoSecundario,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
