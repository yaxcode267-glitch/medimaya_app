import 'package:medimaya_app/shared/api/network/http_client.dart';

import '../model/user_model.dart';

class UserService {
  Future<List<UserSummary>> list({
    String active = 'all',
    String search = '',
  }) async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/users',
      queryParameters: {'active': active, 'search': search.trim()},
    );
    return (response.data!['data'] as List)
        .map((item) => UserSummary.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<UserDetail> get(String id) async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/users/$id',
    );
    return UserDetail.fromJson(
      Map<String, dynamic>.from(response.data!['data']),
    );
  }

  Future<List<UserRole>> roles() async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/users/roles/forms',
    );
    return (response.data!['data'] as List)
        .map((item) => UserRole.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> save(UserInput input, {String? id}) async {
    if (id == null) {
      await HttpClient.httpClient.post<dynamic>('/users', data: input.toJson());
    } else {
      await HttpClient.httpClient.put<dynamic>(
        '/users/$id',
        data: input.toJson(),
      );
    }
  }

  Future<void> setActive(String id, bool active) async {
    await HttpClient.httpClient.patch<dynamic>(
      '/users/$id/${active ? 'activate' : 'deactivate'}',
    );
  }

  Future<void> resetPassword(String id) async {
    await HttpClient.httpClient.patch<dynamic>('/users/$id/reset-password');
  }
}
