import 'package:dio/dio.dart';

import 'package:medimaya_app/shared/api/network/http_client.dart';

// Model
import '../model/product.model.dart';

class ProductService {
  Future<List<Product>> list({
    String active = 'all',
    String? search,
    String? categoryId,
  }) async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/products',
      queryParameters: {
        if (active == 'active') 'active': 'true',
        if (active == 'inactive') 'active': 'false',
        if (search != null && search.trim().isNotEmpty) 'search': search,
        if (categoryId != null && categoryId.isNotEmpty)
          'category_id': categoryId,
      },
    );
    final raw = (response.data?['data'] as List?) ?? const [];
    return raw
        .whereType<Map>()
        .map((e) => Product.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<ProductDetail> get(String id) async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/products/$id',
    );
    final data = (response.data?['data'] as Map?)?.cast<String, dynamic>();
    return ProductDetail.fromJson(data ?? const {});
  }

  Future<void> create(ProductInput input, {MultipartFile? image}) async {
    await HttpClient.httpClient.post<Object?>(
      '/products',
      data: _body(input, image),
    );
  }

  Future<void> update(
    String id,
    ProductInput input, {
    MultipartFile? image,
  }) async {
    await HttpClient.httpClient.put<Object?>(
      '/products/$id',
      data: _body(input, image),
    );
  }

  Future<void> activate(String id) async {
    await HttpClient.httpClient.patch('/products/$id/activate');
  }

  Future<void> deactivate(String id) async {
    await HttpClient.httpClient.patch('/products/$id/deactivate');
  }

  /// Con imagen el cuerpo va como `multipart/form-data`.
  ///
  /// Los nulos viajan como cadena vacía y no se omiten: el backend solo toca lo
  /// que viene en la petición (`sometimes`), así que omitirlos impediría borrar
  /// una descripción o una categoría. Laravel convierte la cadena vacía en
  /// `null` antes de validar.
  Object _body(ProductInput input, MultipartFile? image) {
    final fields = input.toJson();

    if (image == null) return fields;

    return FormData.fromMap({
      for (final entry in fields.entries) entry.key: '${entry.value ?? ''}',
      'image': image,
    });
  }
}
