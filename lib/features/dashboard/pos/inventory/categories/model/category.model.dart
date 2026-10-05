// Utils
import 'package:medimaya_app/shared/utils/date_utils.dart';
import 'package:medimaya_app/shared/utils/user_model.dart';

/// Categoría del inventario tal como la devuelve el listado
/// (GET `/product-categories`).
class Category {
  final String id;
  final String name;
  final String? description;
  final bool active;
  final DateTime? deletedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.active = true,
    this.deletedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      active: json['active'] == true,
      deletedAt: DateUtils.tryParse(json['deleted_at']),
    );
  }

  /// El backend desactiva con `deleted_at` (soft delete), por eso una
  /// categoría desactivada sigue apareciendo en el listado.
  bool get deleted => deletedAt != null;

  String get descriptionText =>
      description?.trim().isNotEmpty == true ? description!.trim() : '';
}

/// Detalle de una categoría (GET `/product-categories/:id`).
///
/// Los campos de auditoría solo llegan cuando el usuario tiene
/// `product_category_audit:view`; por eso son opcionales.
class CategoryDetail {
  final String id;
  final String name;
  final String? description;
  final bool active;
  final int productsCount;
  final DateTime? createdAt;
  final UserProfile? createdBy;
  final DateTime? updatedAt;
  final UserProfile? updatedBy;
  final DateTime? deletedAt;
  final UserProfile? deletedBy;

  const CategoryDetail({
    required this.id,
    required this.name,
    this.description,
    this.active = true,
    this.productsCount = 0,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      active: json['active'] == true,
      productsCount: (json['products_count'] as num?)?.toInt() ?? 0,
      createdAt: DateUtils.tryParse(json['created_at']),
      createdBy: UserProfile.tryParse(json['created_by']),
      updatedAt: DateUtils.tryParse(json['updated_at']),
      updatedBy: UserProfile.tryParse(json['updated_by']),
      deletedAt: DateUtils.tryParse(json['deleted_at']),
      deletedBy: UserProfile.tryParse(json['deleted_by']),
    );
  }

  /// `true` cuando el backend envió el bloque de auditoría.
  bool get hasAudit => createdAt != null || updatedAt != null;
}

/// Cuerpo de creación y edición (POST/PUT `/product-categories`).
class CategoryInput {
  final String name;
  final String? description;

  const CategoryInput({required this.name, this.description});

  Map<String, dynamic> toJson() => {'name': name, 'description': description};
}
