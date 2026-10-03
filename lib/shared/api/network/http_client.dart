import 'package:dio/dio.dart';

// Config
import '../config/api_config.dart';

// Interceptors
import '../interceptors/alert_interceptor.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/session_interceptor.dart';

abstract class HttpClient {
  static final bareHttp = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(seconds: 5),
      headers: {'Accept': 'application/json'},
    ),
  );

  static final httpClient = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(seconds: 5),
      headers: {'Accept': 'application/json'},
    ),
  );

  static void configure({
    Future<void> Function()? refresh,
    void Function()? onSessionExpired,
  }) {
    httpClient.interceptors.addAll([
      AuthInterceptor(),
      SessionInterceptor(
        client: httpClient,
        refresh: refresh ?? () async {},
        onExpired: onSessionExpired,
      ),
      AlertInterceptor(),
    ]);
  }
}
