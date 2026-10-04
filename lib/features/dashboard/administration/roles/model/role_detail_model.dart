// Utils
import 'package:medimaya_app/shared/utils/date_utils.dart';
import 'package:medimaya_app/shared/utils/user_model.dart';

/// Detalle completo de un rol (GET `/roles/:id`).
///
/// A diferencia de [Role], aquí se incluyen los ids de los permisos
/// asignados y la información de auditoría (quién y cuándo lo creó/actualizó).
class RoleDetail {
  final String id;
  final String name;
  final String? description;
  final bool active;
  final List<String> permissions;
  final int usersCount;
  final DateTime? createdAt;
  final UserProfile? createdBy;
  final DateTime? updatedAt;
  final UserProfile? updatedBy;
  final DateTime? deletedAt;
  final UserProfile? deletedBy;

  const RoleDetail({
    required this.id,
    required this.name,
    this.description,
    this.active = true,
    this.permissions = const [],
    this.usersCount = 0,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  factory RoleDetail.fromJson(Map<String, dynamic> json) {
    return RoleDetail(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      active: json['active'] == true,
      permissions:
          (json['permissions'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      usersCount: (json['users_count'] as num?)?.toInt() ?? 0,
      createdAt: DateUtils.tryParse(json['created_at']),
      createdBy: UserProfile.tryParse(json['created_by']),
      updatedAt: DateUtils.tryParse(json['updated_at']),
      updatedBy: UserProfile.tryParse(json['updated_by']),
      deletedAt: DateUtils.tryParse(json['deleted_at']),
      deletedBy: UserProfile.tryParse(json['deleted_by']),
    );
  }
}
