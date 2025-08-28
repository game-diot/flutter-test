import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../network/Post/models/login_page/login_request.dart';
import '../../network/Post/services/login_page/login_request.dart';
import '../../network/Post/models/login_page/register_request.dart';
import '../../network/Post/services/login_page/register_request.dart';
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

Future<bool> registerUser(String username, String password, String phone, String smsCode) async {
  try {
    RegisterRequest request = RegisterRequest(
      username: username,
      password: password,
      phone: phone,
      smsCode: smsCode,
    );

    bool success = await AuthRegisterService.register(request);

    if (success) {
      // 注册成功可以直接登录或者提示用户登录
      print("注册成功");
    }

    return success;
  } catch (e) {
    print("AuthProvider register异常: $e");
    return false;
  }
}

  /// 登录功能
  Future<bool> login(String username, String password) async {
    try {
      LoginRequest request = LoginRequest(username: username, password: password);
      bool loginSuccess = await AuthLoginService.login(request);

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
    } catch (e) {
      print("AuthProvider login异常: $e");
      return false;
    }
  }

  /// 注销功能
  Future<void> logout() async {
    _isLoggedIn = false;
    _username = null;
    _password = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 清空 SharedPreferences 中的登录信息

    notifyListeners(); // 通知 UI 更新
  }
}
