import 'package:flutter/material.dart';
import 'text_field_widget.dart';
import 'captcha_button.dart';
import 'login_form_country_widget.dart';
import 'switch_buttons.dart';
import 'package:provider/provider.dart';
import '../../../../providers/login/login.dart';
import '../../../../localization/lang.dart'; // 替换为实际路径

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
  final TextEditingController confirmPasswordController = TextEditingController();

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

  /// 前端表单校验
  bool _validateForm() {

    if (widget.isPhoneSelected) {
      if (phoneController.text.isEmpty) {
        _showSnackBar(Lang.t('enter_phone'));
        return false;
      }
      if (captchaController.text.isEmpty) {
        _showSnackBar(Lang.t('captcha_empty'));
        return false;
      }
    } else {
      if (emailController.text.isEmpty) {
        _showSnackBar(Lang.t('email_empty'));
        return false;
      }
    }

    if (passwordController.text.isEmpty) {
      _showSnackBar(Lang.t('password_empty'));
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar(Lang.t('password_mismatch'));
      return false;
    }

    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// 注册闭环逻辑（注册成功自动登录）
  Future<void> _onRegisterPressed() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();
    String smsCode = captchaController.text.trim();

    bool success = await authProvider.registerUser(username, password, phone, smsCode);

    setState(() => _isLoading = false);

    if (success) {
      _showSnackBar(Lang.t('register_success'));
      Future.delayed(const Duration(seconds: 1), () {
        widget.onSwitchToLogin?.call();
      });
    } else {
      _showSnackBar(Lang.t('register_failed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchButtons(
          isFirstSelected: widget.isPhoneSelected,
          labels: [Lang.t('phone'), Lang.t('email')],
          onSwitch: widget.onSwitch,
        ),
        const SizedBox(height: 16),
        if (widget.isPhoneSelected)
          TextField(
            controller: phoneController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: Lang.t('enter_phone'),
              hintStyle: const TextStyle(color: Colors.black54),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color.fromRGBO(244, 244, 244, 1), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color.fromRGBO(244, 244, 244, 1), width: 1),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 80,
                      child: CountrySelectWidget(
                        onSelected: (country) => setState(() => selectedCountry = country.toJson()),
                      ),
                    ),
                    const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
                  ],
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 120, minHeight: 0),
            ),
            keyboardType: TextInputType.phone,
          )
        else
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  controller: emailController,
                  hint: Lang.t('enter_email'),
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
                      .map((suffix) => DropdownMenuItem(
                            value: suffix,
                            child: Text(Lang.t(suffix)),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedEmailSuffix = value!),
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFieldWidget(
                controller: captchaController,
                hint: Lang.t('enter_captcha'),
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
        TextFieldWidget(
          controller: passwordController,
          hint: Lang.t('enter_password'),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        TextFieldWidget(
          controller: confirmPasswordController,
          hint: Lang.t('enter_password_again'),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _onRegisterPressed,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(Lang.t('register'), style: const TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color.fromRGBO(244, 244, 245, 1),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        TextButton(
          onPressed: widget.onSwitchToLogin,
          child: Text(
            Lang.t('have_account_login'),
            style: const TextStyle(color: Color(0xFFedb023), fontSize: 18),
          ),
        ),
      ],
    );
  }
}
