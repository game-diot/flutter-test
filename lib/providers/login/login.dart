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

  // 新增：保存账号密码用于自动填充
  String? _savedUsername;
  String? _savedPassword;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get password => _password;
  String? get savedUsername => _savedUsername;
  String? get savedPassword => _savedPassword;

  AuthProvider() {
    _loadSavedAuth();
  }

  /// 加载本地登录状态及保存的账号密码
  Future<void> _loadSavedAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _username = prefs.getString('username');
    _password = prefs.getString('password');

    // 读取保存的账号密码
    _savedUsername = prefs.getString('saved_username');
    _savedPassword = prefs.getString('saved_password');

    notifyListeners();
  }

  /// 保存账号密码，用于自动填充
  Future<void> _saveCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_username', username);
    await prefs.setString('saved_password', password);

    _savedUsername = username;
    _savedPassword = password;
    notifyListeners();
  }

  /// 注册功能（注册成功后自动登录并保存账号密码）
  Future<bool> registerUser(
      String username, String password, String phone, String smsCode) async {
    try {
      RegisterRequest request = RegisterRequest(
        username: username,
        password: password,
        phone: phone,
        smsCode: smsCode,
      );

      bool success = await AuthRegisterService.register(request);

      if (success) {
        print("注册成功，自动登录...");
        bool loginSuccess = await login(username, password);
        if (loginSuccess) {
          await _saveCredentials(username, password); // 保存账号密码
        }
        return loginSuccess;
      }

      return false;
    } catch (e) {
      print("AuthProvider register异常: $e");
      return false;
    }
  }

  /// 登录功能（登录成功后保存账号密码）
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

        await _saveCredentials(username, password); // 保存账号密码

        notifyListeners();
      }

      return loginSuccess;
    } catch (e) {
      print("AuthProvider login异常: $e");
      return false;
    }
  }

  /// 注销功能（保留账号密码，仅清除登录状态）
  Future<void> logout() async {
    _isLoggedIn = false;
    _username = null;
    _password = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');
    await prefs.remove('password');

    notifyListeners();
  }

  /// 判断用户是否已登录（可用于 App 启动检查）
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _username = prefs.getString('username');
    _password = prefs.getString('password');

    _savedUsername = prefs.getString('saved_username');
    _savedPassword = prefs.getString('saved_password');

    notifyListeners();
    return _isLoggedIn;
  }
}
