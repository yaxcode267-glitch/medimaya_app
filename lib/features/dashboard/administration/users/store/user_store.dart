import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:medimaya_app/shared/api/error/api_error.dart';

import '../model/user_model.dart';
import '../service/user_service.dart';

class UserStore extends ChangeNotifier {
  UserStore._();
  static final instance = UserStore._();
  final _service = UserService();
  List<UserSummary> users = [];
  String active = 'all', search = '';
  String? error;
  bool loading = false, saving = false;
  int _request = 0;

  Future<void> load() async {
    final request = ++_request;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await _service.list(active: active, search: search);
      if (request == _request) users = result;
    } on DioException catch (e) {
      if (request == _request) {
        users = [];
        error = ApiError.fromDio(e).message;
      }
    } finally {
      if (request == _request) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<UserDetail> detail(String id) => _service.get(id);
  Future<List<UserRole>> roles() => _service.roles();

  Future<bool> save(UserInput input, {String? id}) =>
      _mutate(() => _service.save(input, id: id));
  Future<bool> setActive(String id, bool active) =>
      _mutate(() => _service.setActive(id, active));
  Future<bool> resetPassword(String id) =>
      _mutate(() => _service.resetPassword(id));

  Future<bool> _mutate(Future<void> Function() action) async {
    if (saving) return false;
    saving = true;
    notifyListeners();
    try {
      await action();
      await load();
      return true;
    } on DioException catch (e) {
      error = ApiError.fromDio(e).message;
      return false;
    } finally {
      saving = false;
      notifyListeners();
    }
  }
}
