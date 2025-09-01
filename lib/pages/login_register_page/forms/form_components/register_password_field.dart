import 'package:flutter/material.dart';
import 'text_field_widget.dart';
import '../../../../localization/i18n/lang.dart';

class RegisterPasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterPasswordField({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}
