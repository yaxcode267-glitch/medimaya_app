import 'package:dio/dio.dart';

// Const
import '../const/const.dart';

// Api
import '../network/storage_client.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers['Authorization'] != null) {
      handler.next(options);
      return;
    }

    final token = await StorageClient.read(StorageKey.access);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
