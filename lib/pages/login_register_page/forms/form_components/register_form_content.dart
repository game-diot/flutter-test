import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/login/login.dart';
import '../../../../localization/i18n/lang.dart';

import 'register_phone_field.dart';
import 'register_email_field.dart';
import 'register_captcha_field.dart';
import 'register_password_field.dart';
import 'register_submit_button.dart';
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
  // 控制器
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String selectedEmailSuffix = "@qq.com";
  String selectedPhoneSuffix = "+86";
  bool _isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    captchaController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  /// 表单校验
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

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  /// 注册逻辑
  Future<void> _onRegisterPressed() async {
    if (!_validateForm()) return;
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.registerUser(
      emailController.text.trim(),
      passwordController.text.trim(),
      phoneController.text.trim(),
      captchaController.text.trim(),
    );

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
        widget.isPhoneSelected
            ? RegisterPhoneField(
                controller: phoneController,
                onCountrySelected: (value) =>
                    setState(() => selectedPhoneSuffix = value.countryCode),
              )
            : RegisterEmailField(
                controller: emailController,
                selectedSuffix: selectedEmailSuffix,
                onSuffixChanged: (val) =>
                    setState(() => selectedEmailSuffix = val),
              ),
        const SizedBox(height: 16),
        RegisterCaptchaField(
          phoneController: phoneController,
          captchaController: captchaController,
          phoneSuffix: selectedPhoneSuffix,
        ),
        const SizedBox(height: 16),
        RegisterPasswordField(
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
        ),
        const SizedBox(height: 16),
        RegisterSubmitButton(
          isLoading: _isLoading,
          onPressed: _onRegisterPressed,
          onSwitchToLogin: widget.onSwitchToLogin,
        ),
      ],
    );
  }
}
