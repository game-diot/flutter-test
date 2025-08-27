import 'package:flutter/material.dart';
import 'text_field_widget.dart';
import 'captcha_button.dart';
import 'login_form_country_widget.dart';
import 'switch_buttons.dart';

class RegisterFormContent extends StatefulWidget {
  final VoidCallback? onSwitchToLogin;
  final bool isPhoneSelected;
  final ValueChanged<bool> onSwitch;

  const RegisterFormContent({
    this.onSwitchToLogin,
    required this.isPhoneSelected,
    required this.onSwitch,
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterFormContent> createState() => _RegisterFormContentState();
}

class _RegisterFormContentState extends State<RegisterFormContent> {
  String selectedPhoneSuffix = "+86";
  String selectedEmailSuffix = "@qq.com";

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Map<String, dynamic>? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部切换按钮
        SwitchButtons(
          isFirstSelected: widget.isPhoneSelected,
          labels: const ['手机号', '邮箱'],
          onSwitch: widget.onSwitch,
        ),

        const SizedBox(height: 16),

        // 替换原来的手机号输入 Row
        if (widget.isPhoneSelected)
          TextField(
            controller: phoneController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: '请输入手机号',
              hintStyle: const TextStyle(color: Colors.black54),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(244, 244, 244, 1),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(244, 244, 244, 1),
                  width: 1,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100,
                      child: CountrySelectWidget(
                        onSelected: (country) =>
                            setState(() => selectedCountry = country.toJson()),
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 120,
                minHeight: 0,
              ),
            ),
            keyboardType: TextInputType.phone,
          )
        else
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  controller: emailController,
                  hint: '请输入邮箱',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 120,
                child: DropdownButton<String>(
                  value: selectedEmailSuffix,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: Colors.white,
                  items: ["@qq.com", "@163.com", "@gmail.com"]
                      .map(
                        (suffix) => DropdownMenuItem(
                          value: suffix,
                          child: Text(
                            suffix,
                            style: const TextStyle(color: Colors.black),
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

        const SizedBox(height: 16),

        // 验证码
        Row(
          children: [
            Expanded(
              child: TextFieldWidget(
                controller: captchaController,
                hint: '请输入验证码',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            CaptchaButton(
              controller: phoneController,
              phoneSuffix: selectedPhoneSuffix,
            ),
          ],
        ),

        const SizedBox(height: 16),
        // 密码
        TextFieldWidget(
          controller: passwordController,
          hint: '请输入密码',
          obscureText: true,
        ),
        const SizedBox(height: 16),
        // 确认密码
        TextFieldWidget(
          controller: confirmPasswordController,
          hint: '请再次输入密码',
          obscureText: true,
        ),

        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // 弹出提示
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('正在跳转到登录页面'),
                  duration: Duration(seconds: 1),
                ),
              );

              // 延迟 1 秒再调用父组件传来的回调
              Future.delayed(const Duration(seconds: 1), () {
                widget.onSwitchToLogin?.call();
              });
            },
            child: const Text('注册', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(244, 244, 245, 1),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        TextButton(
          onPressed: widget.onSwitchToLogin,
          child: const Text(
            '已有账号？去登录',
            style: TextStyle(color: Color(0xFFedb023), fontSize: 18),
          ),
        ),
      ],
    );
  }
}
