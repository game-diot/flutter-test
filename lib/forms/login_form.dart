import 'package:flutter/material.dart';
import '../home_page/home.dart';
import '../network/models/login_area.dart';
import '../network/services/login_area.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        "https://us14-h5.yanshi.lol/api/app-api/system/auth/login";

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
            "Origin": "https://us14-h5.yanshi.lol",
            "Referer": "https://us14-h5.yanshi.lol/home",
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

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isCountryLoading = true;

  List<Country> countryList = [];
  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  void _loadCountries() async {
    try {
      final countries = await fetchCountries();
      setState(() {
        countryList = countries;
        selectedCountry = countries.firstWhere(
          (c) => c.isDefault,
          orElse: () => countries[0],
        );
        _isCountryLoading = false;
      });
    } catch (e) {
      print("获取国家列表失败: $e");
      setState(() => _isCountryLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    backgroundColor:
                        isPhoneSelected ? Color(0xFFf4f4f5) : Colors.white,
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
                    backgroundColor:
                        !isPhoneSelected ? Color(0xFFf4f4f5) : Colors.white,
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
            _isCountryLoading
                ? Center(child: CircularProgressIndicator())
                : Row(
                    children: [
                      Container(
                        width: 100,
                        child: DropdownButton<Country>(
                          value: selectedCountry,
                          isExpanded: true,
                          underline: SizedBox(),
                          items: countryList.map((country) {
                            return DropdownMenuItem<Country>(
                              value: country,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 150,
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: country.iconUrl,
                                      width: 40,
                                      height: 20,
                                      placeholder: (context, url) => SizedBox(
                                          width: 40,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 1.5)),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error, size: 20),
                                    ),

                                    SizedBox(width: 5),
                                    Text(
                                      '+${country.areaCode} ',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (Country? value) {
                            setState(() => selectedCountry = value);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            hintText: '请输入手机号',
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
                    decoration: InputDecoration(
                      hintText: '请输入邮箱',
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
                    value: selectedEmailSuffix,
                    isExpanded: true,
                    underline: SizedBox(),
                    items: ["@qq.com", "@163.com", "@gmail.com"]
                        .map((suffix) => DropdownMenuItem(
                              value: suffix,
                              child: Text(suffix),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedEmailSuffix = value!),
                  ),
                ),
              ],
            ),
          SizedBox(height: 22),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
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
                          ? "${phoneController.text}"
                          : "${emailController.text}";
                      String password = passwordController.text;

                      bool success = await AuthService.login(
                        username: username,
                        password: password,
                        areaCode: selectedCountry?.areaCode ?? '1',
                      );

                      setState(() => _isLoading = false);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success ? "登录成功" : "登录失败，请检查用户名或密码"),
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
              Text('登录即表示同意'),
              TextButton(
                onPressed: () {},
                child: Text('使用协议', style: TextStyle(color: Color(0xFFedb023))),
              ),
              Text('/'),
              TextButton(
                onPressed: () {},
                child: Text('隐私协议', style: TextStyle(color: Color(0xFFedb023))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
