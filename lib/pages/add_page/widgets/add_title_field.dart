import 'package:flutter/material.dart';
import '../../../../../localization/i18n/lang.dart';

class AddTitleField extends StatelessWidget {
  const AddTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 30,
      decoration: InputDecoration(
        hintText: Lang.t('enter_post_title'),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(241, 245, 249, 0.1),
            width: 0.1,
          ),
        ),
        counterText: '',
      ),
    );
  }
}
