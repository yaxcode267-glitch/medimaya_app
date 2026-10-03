import 'package:medimaya_app/shared/api/network/http_client.dart';

// Model
import '../model/patient_profile.dart';

class PatientService {
  /// Ficha del paciente autenticado con el guard `api_paciente`.
  Future<PatientProfile> profile() async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/auth/paciente/perfil',
    );

    final data = (response.data?['data'] as Map?)?.cast<String, dynamic>();

    return PatientProfile.fromJson(data ?? const {});
  }
}
