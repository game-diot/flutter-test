import 'dart:convert';
import 'package:dio/dio.dart';
import '../../models/login_page/register_request.dart';

class AuthRegisterService {
  static final Dio _dio = Dio();
  static const String _registerUrl = "https://us15-h5.yanshi.lol/api/app-api/system/auth/sms-register";

  /// 注册请求
  static Future<bool> register(RegisterRequest request) async {
    try {
      Response response = await _dio.post(
        _registerUrl,
        data: jsonEncode(request.toJson()),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json, text/plain, */*",
            "Origin": "https://us15-h5.yanshi.lol",
            "Referer": "https://us15-h5.yanshi.lol/home",
            "User-Agent":
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                "(KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
          },
        ),
      );

      print("注册返回: ${response.data}");

      // 假设接口成功返回 code=0
      return response.statusCode == 200 && response.data['code'] == 0;
    } catch (e) {
      print("注册异常: $e");
      return false;
    }
  }
}
