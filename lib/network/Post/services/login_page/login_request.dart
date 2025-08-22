import 'dart:convert';
import 'package:dio/dio.dart';
import '../../models/login_page/login_request.dart';

class AuthService {
  static final Dio _dio = Dio();
  static const String _loginUrl = "https://us12-h5.yanshi.lol/api/app-api/system/auth/login";

  /// 登录请求
  static Future<bool> login(LoginRequest request) async {
    try {
      Response response = await _dio.post(
        _loginUrl,
        data: jsonEncode(request.toJson()),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json, text/plain, */*",
            "Origin": "https://us12-h5.yanshi.lol",
            "Referer": "https://us12-h5.yanshi.lol/home",
            "User-Agent":
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                "(KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
          },
        ),
      );

      print("登录返回: ${response.data}");
      return response.statusCode == 200 && response.data['code'] == 0;
    } catch (e) {
      print("登录异常: $e");
      return false;
    }
  }
}
