import 'package:flutter/material.dart';
import 'form_components/register_form_container.dart';

class RegisterForm extends StatelessWidget {
  final VoidCallback? onSwitchToLogin;

  const RegisterForm({this.onSwitchToLogin, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegisterFormContainer(onSwitchToLogin: onSwitchToLogin);
  }
}
