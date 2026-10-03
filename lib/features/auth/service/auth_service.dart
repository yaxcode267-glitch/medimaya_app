import 'package:dio/dio.dart';

// Models
import '../model/auth_model.dart';

// Const
import 'package:medimaya_app/shared/api/const/const.dart';

// Api
import 'package:medimaya_app/shared/api/error/api_error.dart';
import 'package:medimaya_app/shared/api/network/http_client.dart';
import 'package:medimaya_app/shared/api/network/storage_client.dart';

/// Autenticación contra los dos guards de la API: el del personal (`api`) y el
/// del portal de paciente (`api_paciente`).
class AuthService {
  /// Login del personal por correo y contraseña.
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await HttpClient.httpClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      await _store(response.data, SessionKind.staff);
    } on DioException catch (e) {
      throw ApiError.fromDio(e);
    }
  }

  /// Login del portal de paciente por fecha de nacimiento + PIN. La API exige
  /// la fecha en `Y-m-d` y el PIN con 6 dígitos.
  Future<void> patientLogin({
    required String birthDate,
    required String pin,
  }) async {
    try {
      final response = await HttpClient.httpClient.post<Map<String, dynamic>>(
        '/auth/paciente/login',
        data: {'fecha_nacimiento': birthDate, 'pin': pin},
      );

      await _store(response.data, SessionKind.patient);
    } on DioException catch (e) {
      throw ApiError.fromDio(e);
    }
  }

  /// Renueva el access token con el refresh token vigente. Es el mismo endpoint
  /// para los dos guards: la API resuelve la sesión probando ambos.
  ///
  /// Va por el cliente sin interceptores para no reentrar en este flujo cuando
  /// la petición la dispara el propio interceptor de sesión.
  Future<void> refresh() async {
    final refreshToken = await StorageClient.read(StorageKey.refresh);

    if (refreshToken == null || refreshToken.isEmpty) {
      throw ApiError(
        statusCode: 401,
        message: 'Tu sesión expiró. Vuelve a iniciar sesión.',
      );
    }

    final kind = await currentSession() ?? SessionKind.staff;

    try {
      final response = await HttpClient.bareHttp.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      await _store(response.data, kind);
    } on DioException catch (e) {
      throw ApiError.fromDio(e);
    }
  }

  Future<void> logout() => _logout('/auth/logout');

  Future<void> patientLogout() => _logout('/auth/paciente/logout');

  /// Guard de la sesión abierta, o `null` si no hay ninguna. Se guarda con la
  /// caducidad del refresh token, así que caduca junto con la sesión.
  static Future<SessionKind?> currentSession() async {
    final value = await StorageClient.read(StorageKey.session);
    return SessionKind.fromLabel(value);
  }

  Future<void> _logout(String path) async {
    try {
      await HttpClient.httpClient.post(path);
    } on DioException {
      // El token puede estar expirado o revocado. La sesión local se cierra
      // igual, que es lo que pidió el usuario.
    } finally {
      await StorageClient.clear();
    }
  }

  Future<void> _store(Object? data, SessionKind kind) async {
    final tokens = AuthTokens.fromJson((data as Map?)?.cast() ?? const {});

    await StorageClient.write(
      StorageKey.access,
      tokens.accessToken.token,
      tokens.accessToken.exp,
    );

    await StorageClient.write(
      StorageKey.refresh,
      tokens.refreshToken.token,
      tokens.expiresAt,
    );

    await StorageClient.write(StorageKey.session, kind.label, tokens.expiresAt);
  }
}
