import 'package:flutter/material.dart';
import '../../home_page/home.dart';
import '../../../../network/Get/models/splash_page/login_area.dart';
import '../../../../network/Post/services/login_page/login_request.dart';
import '../../../../network/Post/models/login_page/login_request.dart';
import 'form_components/login_switch_buttons.dart';
import 'form_components/login_phone_input.dart';
import 'form_components/login_email_input.dart';
import 'form_components/login_password_input.dart';
import 'form_components/login_button.dart';
import 'form_components/login_register_button.dart';
import 'form_components/login_agreement.dart';

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
  Country? selectedCountry;

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    String username = isPhoneSelected
        ? phoneController.text
        : emailController.text + selectedEmailSuffix;
    String password = passwordController.text;

    final request = LoginRequest(
      username: username,
      password: password,
      areaCode: selectedCountry?.areaCode ?? '1',
    );

    bool success = await AuthService.login(request);
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "登录成功" : "登录失败，请检查用户名或密码")),
    );

    if (success) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
      widget.onLoginSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              LoginSwitchButtons(
                isPhoneSelected: isPhoneSelected,
                onSwitch: (val) => setState(() => isPhoneSelected = val),
              ),
              const SizedBox(height: 28),
              isPhoneSelected
                  ? LoginPhoneInput(
                      controller: phoneController,
                      onCountrySelected: (country) =>
                          setState(() => selectedCountry = country),
                    )
                  : LoginEmailInput(
                      controller: emailController,
                      selectedSuffix: selectedEmailSuffix,
                      onSuffixChanged: (val) =>
                          setState(() => selectedEmailSuffix = val),
                    ),
              const SizedBox(height: 22),
              LoginPasswordInput(controller: passwordController),
              const SizedBox(height: 28),
              LoginButton(
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 18),
              LoginRegisterButton(onSwitchToRegister: widget.onSwitchToRegister),
              const SizedBox(height: 18),
              const LoginAgreement(),
            ],
          ),
        ),
      ),
    );
  }
}
