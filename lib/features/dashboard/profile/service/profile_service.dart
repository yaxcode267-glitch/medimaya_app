import 'package:medimaya_app/shared/api/network/http_client.dart';

import '../model/profile_model.dart';

class ProfileService {
  Future<ProfileResponse> get() async {
    final response = await HttpClient.httpClient.get<Map<String, dynamic>>(
      '/profile',
    );

    return ProfileResponse.fromJson(
      Map<String, dynamic>.from(response.data!['data']),
    );
  }
}
