import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home_page/home.dart';

import 'form_components/switch_buttons.dart';
import 'form_components/login_phone_input.dart';
import 'form_components/login_email_input.dart';
import 'form_components/login_password_input.dart';
import 'form_components/login_button.dart';
import 'form_components/login_register_button.dart';
import 'form_components/login_agreement.dart';
import '../../../providers/login/login.dart';
import '../../../localization/i18n/lang.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onSwitchToRegister;
  final VoidCallback? onLoginSuccess;

  const LoginForm({this.onSwitchToRegister, this.onLoginSuccess, Key? key})
    : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isPhoneSelected = true;
  String selectedEmailSuffix = "@qq.com";

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.savedUsername != null) {
      phoneController.text = authProvider.savedUsername!;
      emailController.text = authProvider.savedUsername!;
    }
    if (authProvider.savedPassword != null) {
      passwordController.text = authProvider.savedPassword!;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// 表单验证
  bool _validateForm() {
    String username = isPhoneSelected
        ? phoneController.text.trim()
        : emailController.text.trim() + selectedEmailSuffix;
    String password = passwordController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(Lang.t("username_empty"))));
      return false;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(Lang.t("password_empty"))));
      return false;
    }
    return true;
  }

  /// 登录逻辑闭环
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_validateForm()) return;

    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    String username = isPhoneSelected
        ? phoneController.text.trim()
        : emailController.text.trim() + selectedEmailSuffix;
    String password = passwordController.text.trim();

    try {
      bool success = await authProvider.login(username, password);

      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? Lang.t("login_success") : Lang.t("login_failed"),
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
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${Lang.t("login_failed")}: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchButtons(
          isFirstSelected: isPhoneSelected,
          labels: [Lang.t("phone"), Lang.t("email")],
          onSwitch: (val) => setState(() => isPhoneSelected = val),
        ),
        const SizedBox(height: 16),
        isPhoneSelected
            ? LoginPhoneInput(
                controller: phoneController,
                onCountrySelected: (_) {},
              )
            : LoginEmailInput(
                controller: emailController,
                selectedSuffix: selectedEmailSuffix,
                onSuffixChanged: (val) =>
                    setState(() => selectedEmailSuffix = val),
              ),
        const SizedBox(height: 16),
        LoginPasswordInput(controller: passwordController),
        const SizedBox(height: 24),
        LoginButton(isLoading: _isLoading, onPressed: _handleLogin),
        const SizedBox(height: 24),
        LoginRegisterButton(onSwitchToRegister: widget.onSwitchToRegister),
        const SizedBox(height: 24),
        const LoginAgreement(),
      ],
    );
  }
}
