import 'package:flutter/material.dart';
import 'text_field_widget.dart';
import 'captcha_button.dart';
import 'login_form_country_widget.dart';
import 'switch_buttons.dart';
import 'package:provider/provider.dart';
import '../../../../providers/login/login.dart';

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

  // 控制器
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false; // 按钮加载状态

  Map<String, dynamic>? selectedCountry;

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    captchaController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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

        // 手机号/邮箱输入
        if (widget.isPhoneSelected)
          TextField(
            controller: phoneController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: '请输入手机号',
              hintStyle: const TextStyle(color: Colors.black54),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 8,
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
                      width: 80,
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
                  items: ["@qq.com", "@163.com", "@gmail.com"]
                      .map(
                        (suffix) => DropdownMenuItem(
                          value: suffix,
                          child: Text(suffix),
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

        // 注册按钮
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() => _isLoading = true);

                    // 调用 Provider 注册
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );

                    String username = usernameController.text;
                    String password = passwordController.text;
                    String phone = phoneController.text;
                    String smsCode = captchaController.text;

                    bool success = await authProvider.registerUser(
                      username,
                      password,
                      phone,
                      smsCode,
                    );

                    setState(() => _isLoading = false);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? '注册成功，即将跳转登录页面' : '注册失败，请检查信息'),
                      ),
                    );

                    if (success) {
                      Future.delayed(const Duration(seconds: 1), () {
                        widget.onSwitchToLogin?.call();
                      });
                    }
                  },
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('注册', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color.fromRGBO(244, 244, 245, 1),
              foregroundColor: Colors.black,
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
