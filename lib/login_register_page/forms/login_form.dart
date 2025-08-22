import 'package:flutter/material.dart';
import '../../home_page/home.dart';
import '../../network/Get/models/splash_page/login_area.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'login_form_widget/login_form_country_widget.dart';

class AuthService {
  static final Dio _dio = Dio();

  static Future<bool> login({
    required String username,
    required String password,
    String type = "1",
    String areaCode = "1",
    bool authCaptcha = false,
    String imgCaptcha = "",
  }) async {
    const String url =
        "https://us12-h5.yanshi.lol/api/app-api/system/auth/login";

    try {
      Response response = await _dio.post(
        url,
        data: jsonEncode({
          "username": username,
          "password": password,
          "type": type,
          "AUTH_LOGIN_CAPTCHA": authCaptcha,
          "areaCode": areaCode,
          "imgCaptcha": imgCaptcha,
        }),
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

class LoginForm extends StatefulWidget {
  final VoidCallback? onSwitchToRegister;
  final VoidCallback? onLoginSuccess;

  const LoginForm({this.onSwitchToRegister, this.onLoginSuccess});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isPhoneSelected = true;
  String selectedEmailSuffix = "@qq.com";
  Country? selectedCountry;
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 不受主题影响
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => isPhoneSelected = true),
                      child: Text('手机号'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPhoneSelected
                            ? Color(0xFFf4f4f5)
                            : Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => isPhoneSelected = false),
                      child: Text('邮箱'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isPhoneSelected
                            ? Color(0xFFf4f4f5)
                            : Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28),
              if (isPhoneSelected)
                Row(
                  children: [
                    Container(
                      width: 100,
                      child: CountrySelectWidget(
                        onSelected: (country) {
                          setState(() => selectedCountry = country);
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: '请输入手机号',
                          hintStyle: TextStyle(color: Colors.black),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: '请输入邮箱',
                          hintStyle: TextStyle(color: Colors.black),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 120,
                      child: DropdownButton<String>(
                         dropdownColor: Colors.white, // ✅ 固定下拉背景色为白色
                        value: selectedEmailSuffix,
                        isExpanded: true,
                        underline: SizedBox(),
                        items: ["@qq.com", "@163.com", "@gmail.com"]
                            .map(
                              (suffix) => DropdownMenuItem(
                                value: suffix,
                                child: Text(
                                  suffix,
                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedEmailSuffix = value!),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 22),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: '请输入密码',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);

                          String username = isPhoneSelected
                              ? phoneController.text
                              : emailController.text + selectedEmailSuffix;
                          String password = passwordController.text;

                          bool success = await AuthService.login(
                            username: username,
                            password: password,
                            areaCode: selectedCountry?.areaCode ?? '1',
                          );

                          setState(() => _isLoading = false);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success ? "登录成功" : "登录失败，请检查用户名或密码",
                              ),
                            ),
                          );

                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomePage()),
                            );
                            widget.onLoginSuccess?.call();
                          }
                        },
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('登录', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF292e38),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18),
              TextButton(
                onPressed: widget.onSwitchToRegister,
                child: Text(
                  '没有账号？去注册',
                  style: TextStyle(color: Color(0xFFedb023), fontSize: 18),
                ),
              ),
              SizedBox(height: 18),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Text('登录即表示同意', style: TextStyle(color: Colors.black)),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '使用协议',
                      style: TextStyle(color: Color(0xFFedb023)),
                    ),
                  ),
                  Text('/'),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '隐私协议',
                      style: TextStyle(color: Color(0xFFedb023)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
