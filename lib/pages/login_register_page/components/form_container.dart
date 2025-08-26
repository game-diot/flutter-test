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
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: screenHeight * 0.60,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: formType == FormType.login
                      ? LoginForm(onSwitchToRegister: onSwitchToRegister)
                      : formType == FormType.register
                          ? RegisterForm(onSwitchToLogin: onSwitchToLogin)
                          : const SizedBox(),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: onClose,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
