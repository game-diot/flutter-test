import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _password;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get password => _password;

  AuthProvider() {
    _loadSavedAuth();
  }

  Future<void> _loadSavedAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _username = prefs.getString('username');
    _password = prefs.getString('password');
    notifyListeners();
  }

  /// 返回 bool 表示登录是否成功
  Future<bool> login(String username, String password) async {
    // 这里加入实际的登录验证逻辑
    bool loginSuccess = true; // 模拟成功，可替换为真实验证

    if (loginSuccess) {
      _username = username;
      _password = password;
      _isLoggedIn = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);
      await prefs.setString('password', password);

      notifyListeners();
    }

    return loginSuccess;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _username = null;
    _password = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }
}
