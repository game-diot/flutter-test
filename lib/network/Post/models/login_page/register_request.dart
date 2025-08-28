class RegisterRequest {
  final String username;
  final String password;
  final String phone;
  final String smsCode; // 短信验证码
  final String areaCode;
  
  RegisterRequest({
    required this.username,
    required this.password,
    required this.phone,
    required this.smsCode,
    this.areaCode = "1",
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "phone": phone,
      "smsCode": smsCode,
      "areaCode": areaCode,
    };
  }
}
