import 'package:dio/dio.dart';

class ApiError implements Exception {
  final int statusCode;
  final String message;
  final Map<String, List<String>> errors;
  final Object? cause;

  ApiError({
    required this.statusCode,
    required this.message,
    this.errors = const {},
    this.cause,
  });

  factory ApiError.fromDio(DioException error) {
    // Errores de conexión (sin respuesta del servidor)
    final connectionMessage = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'La conexión tardó demasiado. Intenta de nuevo.',
      DioExceptionType.connectionError =>
        'No se pudo conectar al servidor. Revisa tu conexión.',
      DioExceptionType.cancel => 'La solicitud fue cancelada.',
      _ => null,
    };

    if (connectionMessage != null) {
      return ApiError(statusCode: 0, message: connectionMessage, cause: error);
    }

    final statusCode = error.response?.statusCode ?? 500;
    final data = error.response?.data;

    // Laravel: { "message": "...", "errors": { "campo": ["msg1", "msg2"] } }
    final errors = <String, List<String>>{};
    String? message;

    if (data is Map) {
      message = data['message']?.toString();

      final rawErrors = data['errors'];
      if (rawErrors is Map) {
        for (final entry in rawErrors.entries) {
          final value = entry.value;
          errors[entry.key.toString()] = value is List
              ? value.map((e) => e.toString()).toList()
              : [value.toString()];
        }
      }
    }

    return ApiError(
      statusCode: statusCode,
      message:
          message ??
          errors.values.firstOrNull?.firstOrNull ??
          'Ha ocurrido un error inesperado.',
      errors: errors,
      cause: error,
    );
  }

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidation => statusCode == 422;
  bool get isServerError => statusCode >= 500;
  bool get isConnectionError => statusCode == 0;
  List<String> get allErrorMessages => errors.values.expand((e) => e).toList();

  String? errorFor(String field) => errors[field]?.firstOrNull;

  @override
  String toString() => message;
}
