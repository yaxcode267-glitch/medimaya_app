import 'dart:async';

import 'package:dio/dio.dart';

// Const
import '../const/const.dart';

// Errors
import '../error/api_error.dart';

// Api
import '../network/storage_client.dart';

// ignore_for_file: prefer_initializing_formals

class SessionInterceptor extends Interceptor {
  static const _excludedPaths = [
    '/auth/login',
    '/auth/refresh',
    '/auth/logout',
    '/auth/paciente/login',
    '/auth/paciente/refresh',
    '/auth/paciente/logout',
  ];
  static const _retriedKey = 'session_retried';

  final Dio _client;
  final Future<void> Function() _refresh;
  final void Function()? _onExpired;

  Future<void>? _refreshing;
  bool _expired = false;

  SessionInterceptor({
    required Dio client,
    required Future<void> Function() refresh,
    void Function()? onExpired,
  }) : _client = client,
       _refresh = refresh,
       _onExpired = onExpired;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final skipped = _excludedPaths.any(request.path.contains);
    final apiError = ApiError.fromDio(err);

    if (skipped || !apiError.isUnauthorized) {
      handler.next(err);
      return;
    }

    if (request.extra[_retriedKey] == true) {
      _expire(err);
      handler.reject(err);
      return;
    }

    request.extra[_retriedKey] = true;

    try {
      _expired = false;
      _refreshing ??= _refresh();
      await _refreshing;
    } on ApiError catch (refreshError) {
      if (refreshError.isUnauthorized) {
        _expire(err);
      }
      handler.reject(err);
      return;
    } on DioException catch (refreshError) {
      if (ApiError.fromDio(refreshError).isUnauthorized) {
        _expire(err);
        handler.reject(err);
        return;
      }
      handler.reject(refreshError.response != null ? refreshError : err);
      return;
    } catch (_) {
      handler.reject(err);
      return;
    } finally {
      _refreshing = null;
    }

    final access = await StorageClient.read(StorageKey.access);

    if (access == null || access.isEmpty) {
      _expire(err);
      handler.reject(err);
      return;
    }

    request.headers['Authorization'] = 'Bearer $access';

    try {
      final response = await _client.fetch<dynamic>(request);
      handler.resolve(response);
    } catch (retryError) {
      handler.reject(retryError is DioException ? retryError : err);
    }
  }

  void _expire(DioException original) {
    if (_expired) return;
    _expired = true;
    unawaited(StorageClient.clear());
    _onExpired?.call();
  }
}
