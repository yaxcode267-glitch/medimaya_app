import 'package:flutter/foundation.dart';

// Model / Service
import '../model/profile_model.dart';
import '../service/profile_service.dart';

// Api
import 'package:medimaya_app/shared/api/const/const.dart';
import 'package:medimaya_app/shared/api/network/storage_client.dart';

class ProfileController extends ChangeNotifier {
  ProfileController._();

  static final ProfileController instance = ProfileController._();

  ProfileUser? user;
  ProfileRole? role;
  List<String> permissions = const [];
  bool loaded = false;
  bool loading = false;

  String get fullName {
    final names = user?.names ?? '';
    final surnames = user?.surnames ?? '';
    return '$names $surnames'.trim();
  }

  String get roleName => role?.name ?? '';

  String get email => user?.email ?? '';

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';

    String letter(String word) =>
        String.fromCharCodes(word.runes.take(1)).toUpperCase();

    if (parts.length == 1) return letter(parts.first);
    return letter(parts.first) + letter(parts.last);
  }

  bool hasPermission(String permission) => permissions.contains(permission);

  void updateUser({
    required String names,
    required String surnames,
    required String email,
  }) {
    final current = user;
    if (current == null) return;

    user = ProfileUser(
      id: current.id,
      email: email,
      names: names,
      surnames: surnames,
      profile: current.profile,
    );
    notifyListeners();
  }

  Future<void> load() async {
    if (loaded || loading) return;
    if (await _loadFromCache()) return;
    await fetch();
  }

  Future<bool> _loadFromCache() async {
    final data = await StorageClient.readJson<Map<String, dynamic>>(
      StorageKey.profile,
    );
    if (data == null || data['role'] == null) return false;
    _apply(ProfileResponse.fromJson(data));
    return true;
  }

  Future<void> fetch() async {
    loading = true;
    try {
      final data = await ProfileService().get();
      _apply(data);
      await StorageClient.writeJson(StorageKey.profile, data.toJson());
    } catch (_) {
      // Sin red o sesión expirada; se conserva el estado previo.
    } finally {
      loading = false;
    }
  }

  void _apply(ProfileResponse data) {
    user = data.user;
    role = data.role;
    permissions = data.permissions;
    loaded = true;
    notifyListeners();
  }

  void reset() {
    user = null;
    role = null;
    permissions = const [];
    loaded = false;
    loading = false;
    notifyListeners();
  }
}
