// lib/services/auth_service.dart
import 'package:dio/dio.dart';
import '../../models/splash_page/register_send_verification_code.dart';

class RegisterSendVerificationCodeService {
  static final Dio _dio = Dio();

  static Future<RegisterSendVerificationCode?> sendCaptcha({
    required String to,
    required String type,
    required String sendType,
    required String areaCode,
  }) async {
    const String baseUrl = 'https://us15-h5.yanshi.lol/api/app-api/system/auth/send-captcha';

    try {
      final response = await _dio.get(baseUrl, queryParameters: {
        'to': to,
        'type': type,
        'sendType': sendType,
        'areaCode': areaCode,
      });

      if (response.statusCode == 200 && response.data['code'] == 0) {
        return RegisterSendVerificationCode.fromJson(response.data);
      } else {
        print("请求失败，状态码：${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("请求出错：$e");
      return null;
    }
  }
}
