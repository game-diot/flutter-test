import 'package:flutter/material.dart';
import 'login_form.dart';
import 'dart:async';
import '../network/Get/services/register_send_verification_code.dart';
import '../network/Get/models/register_send_verification_code.dart';
import 'login_form_widget/login_form_country_widget.dart';
class RegisterForm extends StatefulWidget {
  final VoidCallback? onSwitchToLogin;

  RegisterForm({this.onSwitchToLogin});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool isPhoneSelected = true;
  String selectedPhoneSuffix = "+86";
  String selectedEmailSuffix = "@qq.com";
  TextEditingController captchaController = TextEditingController();
  int _countdown = 0;
  Timer? _timer;
  bool _isSending = false;
  // 定义国家数据类型
  Map<String, dynamic>? selectedCountry;

  final List<String> phoneSuffixes = ["+86", "+99", "+66"];
  final List<String> emailSuffixes = ["@qq.com", "@163.com", "@gmail.com"];

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 30;
      _isSending = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        if (_countdown == 0) {
          _timer?.cancel();
          _isSending = false;
        }
      });
    });
  }

  void _sendCaptcha() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('请输入手机号', style: TextStyle(color: Colors.black),)));
      return;
    }
    try {
      // 调用你的服务函数
      final response = await RegisterSendVerificationCodeService.sendCaptcha(
        to: phone,
        type: '1', // 根据接口定义，默认是 '1'
        sendType: '1', // 默认 '1'
        areaCode: selectedPhoneSuffix.replaceAll("+", ""), // 去掉加号
      );

      if (response != null && response.code == 0) {
        // 成功，开始倒计时
        _startCountdown();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('验证码发送成功')));
      } else {
        // 后端返回失败
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response?.msg ?? '发送失败')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('网络请求失败：$e')));
    }
  }
  // TODO: 这里调用你的 AuthService.sendCaptcha()
  // 示例：
  // AuthService.sendCaptcha(...)

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部切换
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
        SizedBox(height: 20),
        // 输入区域
        isPhoneSelected
            ? Row(
  children: [
    Container(
      width: 100,
      child: CountrySelectWidget(
        onSelected: (country) {
          setState(() => selectedCountry = country.toJson());
        },
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: TextField(
        controller: phoneController,
    
        decoration: InputDecoration(
          hintText: '请输入手机号',
          hintStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        keyboardType: TextInputType.phone,
      ),
    ),
  ],
)

            : Row(
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
                      items: emailSuffixes
                          .map(
                            (suffix) => DropdownMenuItem(
                              value: suffix,
                              child: Text(suffix, style: TextStyle(color: Colors.black),),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedEmailSuffix = value!),
                    ),
                  ),
                ],
              ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: captchaController,
                style: TextStyle(color: Colors.black), 
                decoration: InputDecoration(
                  hintText: '请输入验证码',
                  hintStyle: TextStyle(color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendCaptcha,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSending ? Colors.grey : Color(0xFFedb023),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(_isSending ? '$_countdown 秒' : '发送验证码'),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        TextField(
          controller: passwordController,
          style: TextStyle(color: Colors.black), 
          obscureText: true,
          decoration: InputDecoration(
            hintText: '请输入密码',
            hintStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        SizedBox(height: 12),
        TextField(
          controller: confirmPasswordController,
          style: TextStyle(color: Colors.black), 
          obscureText: true,
          decoration: InputDecoration(
            hintText: '请再次输入密码',
            hintStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: widget.onSwitchToLogin,
            child: Text('注册', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF292e38),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        TextButton(
          onPressed: widget.onSwitchToLogin,
          child: Text(
            '没有账号？去登录',
            style: TextStyle(color: Color(0xFFedb023), fontSize: 18),
          ),
        ),
      ],
    );
  }
}
