import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medimaya_app/shared/api/const/const.dart';
import 'package:medimaya_app/shared/api/error/api_error.dart';
import 'package:medimaya_app/shared/api/interceptors/auth_interceptor.dart';
import 'package:medimaya_app/shared/api/interceptors/session_interceptor.dart';
import 'package:medimaya_app/shared/api/network/storage_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('Agrega el token y reintenta con el token renovado', () async {
    await StorageClient.write(
      StorageKey.access,
      'anterior',
      DateTime.now().add(const Duration(hours: 1)),
    );
    final client = Dio();
    addTearDown(client.close);
    var refreshes = 0;
    final headers = <Object?>[];
    client.interceptors.addAll([
      AuthInterceptor(),
      SessionInterceptor(
        client: client,
        refresh: () async {
          refreshes++;
          await StorageClient.write(
            StorageKey.access,
            'nuevo',
            DateTime.now().add(const Duration(hours: 1)),
          );
        },
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          headers.add(options.headers['Authorization']);
          if (headers.length == 1) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(requestOptions: options, statusCode: 401),
                type: DioExceptionType.badResponse,
              ),
              true,
            );
          } else {
            handler.resolve(Response(requestOptions: options, statusCode: 200));
          }
        },
      ),
    ]);
    final response = await client.get<dynamic>('/profile');
    expect(response.statusCode, 200);
    expect(refreshes, 1);
    expect(headers, ['Bearer anterior', 'Bearer nuevo']);
  });

  for (final status in [401, 500, 0]) {
    test('Expira solo ante ApiError 401: estado $status', () async {
      await StorageClient.write(
        StorageKey.refresh,
        'refresh-guardado',
        DateTime.now().add(const Duration(hours: 1)),
      );
      final client = Dio();
      addTearDown(client.close);
      var expired = false;
      client.interceptors.addAll([
        SessionInterceptor(
          client: client,
          refresh: () async => throw ApiError(
            statusCode: status,
            message: 'Error de renovación',
          ),
          onExpired: () => expired = true,
        ),
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(requestOptions: options, statusCode: 401),
                type: DioExceptionType.badResponse,
              ),
              true,
            );
          },
        ),
      ]);
      await expectLater(
        client.get<dynamic>('/profile'),
        throwsA(isA<DioException>()),
      );
      expect(expired, status == 401);
      expect(
        await StorageClient.read(StorageKey.refresh),
        status == 401 ? isNull : 'refresh-guardado',
      );
    });
  }
}
