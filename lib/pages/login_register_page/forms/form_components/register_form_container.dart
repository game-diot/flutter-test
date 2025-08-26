import 'package:flutter/material.dart';
import 'register_form_content.dart';

class RegisterFormContainer extends StatelessWidget {
  final VoidCallback? onSwitchToLogin;

  const RegisterFormContainer({this.onSwitchToLogin, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: screenHeight * 0.70,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: SingleChildScrollView(
          child: RegisterFormContent(onSwitchToLogin: onSwitchToLogin),
        ),
      ),
    );
  }
}
