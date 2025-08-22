class LoginRequest {
  final String username;
  final String password;
  final String type;
  final String areaCode;
  final bool authCaptcha;
  final String imgCaptcha;

  LoginRequest({
    required this.username,
    required this.password,
    this.type = "1",
    this.areaCode = "1",
    this.authCaptcha = false,
    this.imgCaptcha = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "type": type,
      "AUTH_LOGIN_CAPTCHA": authCaptcha,
      "areaCode": areaCode,
      "imgCaptcha": imgCaptcha,
    };
  }
}
