import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageClient {
  static const _storage = FlutterSecureStorage();

  static Future<void> write(
    String key,
    String value,
    DateTime expiresAt,
  ) async {
    if (DateTime.now().isAfter(expiresAt)) {
      await delete(key);
      return;
    }

    final payload = {'value': value, 'expiresAt': expiresAt.toIso8601String()};

    await _storage.write(key: key, value: jsonEncode(payload));
  }

  static Future<String?> read(String key) async {
    final value = await _storage.read(key: key);

    if (value == null) {
      return null;
    }

    try {
      final data = jsonDecode(value) as Map<String, dynamic>;

      final expiresAt = DateTime.tryParse(data['expiresAt']?.toString() ?? '');

      if (expiresAt == null || DateTime.now().isAfter(expiresAt)) {
        await delete(key);
        return null;
      }

      return data['value']?.toString();
    } catch (_) {
      await delete(key);
      return null;
    }
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> writeJson<T>(String key, T value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  static Future<T?> readJson<T>(String key) async {
    final value = await _storage.read(key: key);

    if (value == null) {
      return null;
    }

    try {
      return jsonDecode(value) as T;
    } catch (_) {
      await delete(key);
      return null;
    }
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
