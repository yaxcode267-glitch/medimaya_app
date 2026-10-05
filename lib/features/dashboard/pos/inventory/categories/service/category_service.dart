import 'package:medimaya_app/shared/api/network/http_client.dart';

// Model
import '../model/category.model.dart';

class CategoryService {
  Future<List<Category>> list({String active = 'all', String? search}) async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/product-categories',
      queryParameters: {
        if (active == 'active') 'active': 'true',
        if (active == 'inactive') 'active': 'false',
        if (search != null && search.trim().isNotEmpty) 'search': search,
      },
    );
    final raw = (response.data?['data'] as List?) ?? const [];
    return raw
        .whereType<Map>()
        .map((e) => Category.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<CategoryDetail> get(String id) async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/product-categories/$id',
    );
    final data = (response.data?['data'] as Map?)?.cast<String, dynamic>();
    return CategoryDetail.fromJson(data ?? const {});
  }

  Future<void> create(CategoryInput input) async {
    await HttpClient.httpClient.post(
      '/product-categories',
      data: input.toJson(),
    );
  }

  Future<void> update(String id, CategoryInput input) async {
    await HttpClient.httpClient.put(
      '/product-categories/$id',
      data: input.toJson(),
    );
  }

  Future<void> activate(String id) async {
    await HttpClient.httpClient.patch('/product-categories/$id/activate');
  }

  Future<void> deactivate(String id) async {
    await HttpClient.httpClient.patch('/product-categories/$id/deactivate');
  }
}
