import 'package:flutter/material.dart';

import 'enums/form_type.dart';
import 'components/buttons.dart';
import 'components/form_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FormType _formType = FormType.none;

  void _showLoginForm() => setState(() => _formType = FormType.login);
  void _showRegisterForm() => setState(() => _formType = FormType.register);
  void _hideForm() => setState(() => _formType = FormType.none);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFedb023),
      body: Stack(
        children: [
          // Logo & 标题
          Align(
            alignment: const Alignment(0, -0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 12),
                const Text(
                  'dlb coin',
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 登录/注册按钮
          if (_formType == FormType.none)
            AuthButtons(
              onLogin: _showLoginForm,
              onRegister: _showRegisterForm,
            ),

          // 底部弹出的登录/注册表单容器
          AuthFormContainer(
            formType: _formType,
            onSwitchToLogin: _showLoginForm,
            onSwitchToRegister: _showRegisterForm,
            onClose: _hideForm,
            screenHeight: screenHeight,
          ),
        ],
      ),
    );
  }
}
