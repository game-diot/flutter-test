import 'package:flutter/material.dart';
import 'text_field_widget.dart';
import 'captcha_button.dart';
import 'login_form_country_widget.dart';

class RegisterFormContent extends StatefulWidget {
  final VoidCallback? onSwitchToLogin;

  const RegisterFormContent({this.onSwitchToLogin, Key? key}) : super(key: key);

  @override
  State<RegisterFormContent> createState() => _RegisterFormContentState();
}

class _RegisterFormContentState extends State<RegisterFormContent> {
  bool isPhoneSelected = true;
  String selectedPhoneSuffix = "+86";
  String selectedEmailSuffix = "@qq.com";

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Map<String, dynamic>? selectedCountry;

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
                  backgroundColor: isPhoneSelected ? Colors.white : Color(0xFFf4f4f5),
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 38),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => isPhoneSelected = false),
                child: Text('邮箱'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isPhoneSelected ? Colors.white : Color(0xFFf4f4f5),
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 38),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        // 输入区域
        if (isPhoneSelected)
          Row(
            children: [
              Container(
                width: 100,
                child: CountrySelectWidget(
                  onSelected: (country) => setState(() => selectedCountry = country.toJson()),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFieldWidget(controller: phoneController, hint: '请输入手机号', keyboardType: TextInputType.phone),
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(controller: emailController, hint: '请输入邮箱', keyboardType: TextInputType.emailAddress),
              ),
              SizedBox(width: 10),
              Container(
                width: 120,
                child: DropdownButton<String>(
                  value: selectedEmailSuffix,
                  isExpanded: true,
                  underline: SizedBox(),
                  dropdownColor: Colors.white,
                  items: ["@qq.com", "@163.com", "@gmail.com"]
                      .map((suffix) => DropdownMenuItem(
                            value: suffix,
                            child: Text(suffix, style: TextStyle(color: Colors.black)),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedEmailSuffix = value!),
                ),
              ),
            ],
          ),

        SizedBox(height: 12),

        // 验证码按钮
        Row(
          children: [
            Expanded(
              child: TextFieldWidget(controller: captchaController, hint: '请输入验证码', keyboardType: TextInputType.number),
            ),
            SizedBox(width: 10),
            CaptchaButton(controller: phoneController, phoneSuffix: selectedPhoneSuffix),
          ],
        ),

        SizedBox(height: 12),
        TextFieldWidget(controller: passwordController, hint: '请输入密码', obscureText: true),
        SizedBox(height: 12),
        TextFieldWidget(controller: confirmPasswordController, hint: '请再次输入密码', obscureText: true),

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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),

        SizedBox(height: 20),
        TextButton(
          onPressed: widget.onSwitchToLogin,
          child: Text('没有账号？去登录', style: TextStyle(color: Color(0xFFedb023), fontSize: 18)),
        ),
      ],
    );
  }
}
