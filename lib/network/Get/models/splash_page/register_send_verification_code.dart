// lib/models/send_captcha_response.dart
class RegisterSendVerificationCode {
  final int code;
  final bool data;
  final String msg;
  final dynamic operation;
  final dynamic filedName;
  final dynamic preAuthorize;

  RegisterSendVerificationCode({
    required this.code,
    required this.data,
    required this.msg,
    this.operation,
    this.filedName,
    this.preAuthorize,
  });

  factory RegisterSendVerificationCode.fromJson(Map<String, dynamic> json) {
    return RegisterSendVerificationCode(
      code: json['code'],
      data: json['data'] ?? false,
      msg: json['msg'] ?? '',
      operation: json['operation'],
      filedName: json['filedName'],
      preAuthorize: json['preAuthorize'],
    );
  }
}
