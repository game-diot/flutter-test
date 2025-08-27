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

  // 上移的偏移量
  final double shiftOffset = _formType != FormType.none ? -50.0 : 0.0;

  return Scaffold(
    backgroundColor: const Color(0xFFedb023),
    body: Stack(
      children: [
        // Logo & 标题
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: screenHeight * 0.2 + shiftOffset, // 根据弹出状态上移
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png', width: 150, height: 100),
              const Text(
                'DLB Coin',
                style: TextStyle(
                  fontFamily: 'CustomFont',
                  color: Colors.black,
                  fontSize: 60,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        // 登录/注册按钮
        if (_formType == FormType.none)
          AuthButtons(onLogin: _showLoginForm, onRegister: _showRegisterForm),

        // 顶部 Header
        if (_formType != FormType.none)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 40 , // 同步上移
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _hideForm,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _formType == FormType.login ? '登录' : '注册',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // 占位
                ],
              ),
            ),
          ),

        // 底部弹出的表单
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