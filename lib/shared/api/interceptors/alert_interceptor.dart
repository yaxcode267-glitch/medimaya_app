import 'package:dio/dio.dart';

// Errors
import '../error/api_error.dart';

// Widget
import '../../ui/widget/common/app_alert.dart';

class AlertInterceptor extends Interceptor {
  final _skippedErrorPaths = [
    '/auth/refresh',
    '/auth/login',
    '/auth/paciente/login',
  ];

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;

    if (data is Map) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        AppAlert.success(message.trim());
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final url = err.requestOptions.path;
    final skipped = _skippedErrorPaths.any(url.contains);
    final apiError = ApiError.fromDio(err);

    if (!skipped && !apiError.isUnauthorized) {
      AppAlert.error(apiError.message);
    }

    handler.next(err);
  }
}
