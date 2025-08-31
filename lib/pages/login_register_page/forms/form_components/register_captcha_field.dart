import 'package:flutter/material.dart';
import 'text_field_widget.dart';
import 'captcha_button.dart';
import '../../../../localization/i18n/lang.dart';

class RegisterCaptchaField extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController captchaController;
  final String phoneSuffix;

  const RegisterCaptchaField({
    super.key,
    required this.phoneController,
    required this.captchaController,
    required this.phoneSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            controller: captchaController,
            hint: Lang.t('enter_captcha'),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 10),
        CaptchaButton(controller: phoneController, phoneSuffix: phoneSuffix),
      ],
    );
  }
}
