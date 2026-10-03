import 'package:flutter_test/flutter_test.dart';
import 'package:medimaya_app/features/auth/model/auth_model.dart';
import 'package:medimaya_app/features/patient/model/patient_profile.dart';

void main() {
  group('AuthTokens', () {
    Map<String, dynamic> payload({
      String access = 'access-1',
      String refresh = 'refresh-1',
    }) => {
      'access_token': {'token': access, 'exp': '2026-10-01T12:00:00+00:00'},
      'refresh_token': {'token': refresh, 'exp': '2026-10-15T12:00:00+00:00'},
    };

    test('lee el par de tokens de la respuesta', () {
      final tokens = AuthTokens.fromJson(payload());

      expect(tokens.accessToken.token, 'access-1');
      expect(tokens.refreshToken.token, 'refresh-1');
    });

    test('la sesión caduca con el refresh token', () {
      final tokens = AuthTokens.fromJson(payload());

      expect(
        tokens.expiresAt.toUtc(),
        DateTime.parse('2026-10-15T12:00:00+00:00'),
      );
    });

    test('no revienta si la respuesta viene sin tokens', () {
      final tokens = AuthTokens.fromJson(const {});

      expect(tokens.accessToken.token, isEmpty);
      expect(tokens.refreshToken.token, isEmpty);
    });
  });

  group('SessionKind', () {
    test('va y vuelve desde la etiqueta guardada', () {
      expect(SessionKind.fromLabel('staff'), SessionKind.staff);
      expect(SessionKind.fromLabel('patient'), SessionKind.patient);
      expect(SessionKind.fromLabel(null), isNull);
      expect(SessionKind.fromLabel('otro'), isNull);
    });
  });

  group('PatientProfile', () {
    test('mapea la ficha y la edad', () {
      final profile = PatientProfile.fromJson({
        'id': 'uuid-1',
        'first_name': 'Ana',
        'last_name': 'Ruiz',
        'birth_date': '1990-05-04',
        'gender': 'F',
        'last_login_at': '2026-09-30T08:15:00+00:00',
      });

      expect(profile.fullName, 'Ana Ruiz');
      expect(profile.gender, 'Femenino');
      expect(profile.birthDate, isNotNull);
      expect(profile.birthDate!.year, 1990);
      expect(profile.birthDate!.month, 5);
      expect(profile.birthDate!.day, 4);
    });

    test('traduce el género de la API', () {
      expect(PatientProfile.genderLabel('M'), 'Masculino');
      expect(PatientProfile.genderLabel('OTRO'), 'Otro');
      expect(PatientProfile.genderLabel(null), 'Sin especificar');
    });

    test('sin fecha de nacimiento la edad es 0', () {
      expect(PatientProfile.fromJson(const {}).age, 0);
    });
  });
}
