// Utils
import 'package:medimaya_app/shared/utils/date_utils.dart';
import 'package:medimaya_app/shared/utils/user_model.dart';

/// Categoría asignada a un producto. Es la misma entidad que gestiona el
/// módulo de categorías, así que se reutiliza su DTO en vez de duplicarlo.
import '../../categories/model/category.model.dart';

/// Producto del inventario tal como lo devuelve el listado (GET `/products`).
class Product {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final double price;
  final bool active;
  final String? categoryId;
  final String? categoryName;
  final DateTime? deletedAt;

  const Product({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.price = 0,
    this.active = true,
    this.categoryId,
    this.categoryName,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      price: parsePrice(json['price']),
      active: json['active'] == true,
      categoryId: json['category_id']?.toString(),
      categoryName: json['category_name']?.toString(),
      deletedAt: DateUtils.tryParse(json['deleted_at']),
    );
  }

  /// El backend desactiva con `deleted_at` (soft delete), por eso un producto
  /// desactivado sigue apareciendo en el listado.
  bool get deleted => deletedAt != null;

  String get descriptionText =>
      description?.trim().isNotEmpty == true ? description!.trim() : '';
}

/// Detalle de un producto (GET `/products/:id`).
///
/// Los campos de auditoría solo llegan con el permiso `products:view_audit`,
/// por eso son opcionales.
class ProductDetail {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final double price;
  final bool active;
  final String? categoryId;
  final Category? category;
  final DateTime? createdAt;
  final UserProfile? createdBy;
  final DateTime? updatedAt;
  final UserProfile? updatedBy;
  final DateTime? deletedAt;
  final UserProfile? deletedBy;

  const ProductDetail({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.price = 0,
    this.active = true,
    this.categoryId,
    this.category,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      price: parsePrice(json['price']),
      active: json['active'] == true,
      categoryId: json['category_id']?.toString(),
      category: _category(json['category']),
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

  String get descriptionText =>
      description?.trim().isNotEmpty == true ? description!.trim() : '';

  /// El backend manda `category: null` cuando el producto no tiene categoría.
  static Category? _category(Object? value) =>
      value is Map ? Category.fromJson(value.cast<String, dynamic>()) : null;
}

/// Cuerpo de creación y edición (POST/PUT `/products`).
///
/// La imagen no viaja aquí: se sube aparte como archivo `image` en
/// `multipart/form-data`, y solo entonces se reemplaza la del producto.
class ProductInput {
  final String name;
  final String? description;
  final double price;
  final String? categoryId;

  const ProductInput({
    required this.name,
    required this.price,
    this.description,
    this.categoryId,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'category_id': categoryId,
  };
}

/// El backend castea `price` a `decimal:2`, así que llega como texto
/// (`"12.50"`); se acepta cualquier forma numérica.
double parsePrice(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse('${value ?? ''}') ?? 0;
}

/// Formato de presentación: siempre dos decimales.
String formatPrice(double price) => price.toStringAsFixed(2);
