import 'package:medimaya_app/shared/api/network/http_client.dart';

// Model
import '../model/permission.model.dart';
import '../model/role.model.dart';
import '../model/role_detail_model.dart';

class RolesService {
  Future<List<Role>> list({String active = 'all', String? search}) async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/roles',
      queryParameters: {
        if (active == 'active') 'active': 'true',
        if (active == 'inactive') 'active': 'false',
        if (search != null && search.trim().isNotEmpty) 'search': search,
      },
    );
    final raw = (response.data?['data'] as List?) ?? const [];
    return raw
        .whereType<Map>()
        .map((e) => Role.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<RoleDetail> get(String id) async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/roles/$id',
    );
    final data = (response.data?['data'] as Map?)?.cast<String, dynamic>();
    return RoleDetail.fromJson(data ?? const {});
  }

  Future<List<PermissionGroup>> permissions() async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/roles/permissions',
    );
    final raw = (response.data?['data'] as List?) ?? const [];
    return raw
        .whereType<Map>()
        .map((e) => PermissionGroup.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<void> create(RolePayload payload) async {
    await HttpClient.httpClient.post('/roles', data: payload.toJson());
  }

  Future<void> update(String id, RolePayload payload) async {
    await HttpClient.httpClient.put('/roles/$id', data: payload.toJson());
  }

  Future<void> activate(String id) async {
    await HttpClient.httpClient.patch('/roles/$id/activate');
  }

  Future<void> deactivate(String id) async {
    await HttpClient.httpClient.patch('/roles/$id/deactivate');
  }
}
