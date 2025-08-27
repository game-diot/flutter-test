import 'package:flutter/material.dart';

import '../enums/form_type.dart';
import '../forms/login_form.dart';
import '../forms/register_form.dart';

class AuthFormContainer extends StatelessWidget {
  final FormType formType;
  final VoidCallback onSwitchToLogin;
  final VoidCallback onSwitchToRegister;
  final VoidCallback onClose;
  final double screenHeight;

  const AuthFormContainer({
    Key? key,
    required this.formType,
    required this.onSwitchToLogin,
    required this.onSwitchToRegister,
    required this.onClose,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: formType != FormType.none ? const Offset(0, 0) : const Offset(0, 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: screenHeight * 0.55, // 固定高度
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10),
            ],
          ),
          // 直接放置表单，键盘弹出时可遮挡
          child: formType == FormType.login
              ? LoginForm(onSwitchToRegister: onSwitchToRegister)
              : formType == FormType.register
                  ? RegisterForm(onSwitchToLogin: onSwitchToLogin)
                  : const SizedBox(),
        ),
      ),
    );
  }
}
