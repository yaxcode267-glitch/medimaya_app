/// Guard con el que se inició la sesión. La API no lo devuelve en la respuesta
/// de login, así que el cliente lo guarda al autenticar.
enum SessionKind {
  staff('staff'),
  patient('patient');

  const SessionKind(this.label);

  final String label;

  static SessionKind? fromLabel(String? label) {
    for (final kind in values) {
      if (kind.label == label) return kind;
    }

    return null;
  }
}

class TokenPayload {
  final String token;
  final DateTime exp;

  const TokenPayload({required this.token, required this.exp});

  factory TokenPayload.fromJson(Map<String, dynamic> json) {
    return TokenPayload(
      token: json['token']?.toString() ?? '',
      exp: parseExp(json['exp']),
    );
  }

  static DateTime parseExp(Object? value) {
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000);
    }

    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  }
}

class AuthTokens {
  final TokenPayload accessToken;
  final TokenPayload refreshToken;

  const AuthTokens({required this.accessToken, required this.refreshToken});

  /// El access token siempre vence antes que el de refresco, así que la
  /// expiración de este último delimita la sesión completa.
  DateTime get expiresAt => refreshToken.exp;

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: TokenPayload.fromJson(
        (json['access_token'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      refreshToken: TokenPayload.fromJson(
        (json['refresh_token'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
    );
  }
}
