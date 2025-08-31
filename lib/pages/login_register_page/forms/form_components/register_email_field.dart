import 'package:flutter/material.dart';
import 'text_field_widget.dart';
import '../../../../localization/i18n/lang.dart';

class RegisterEmailField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedSuffix;
  final ValueChanged<String> onSuffixChanged;

  const RegisterEmailField({
    super.key,
    required this.controller,
    required this.selectedSuffix,
    required this.onSuffixChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            controller: controller,
            hint: Lang.t('enter_email'),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: DropdownButton<String>(
            value: selectedSuffix,
            isExpanded: true,
            underline: const SizedBox(),
            items: ["@qq.com", "@163.com", "@gmail.com"]
                .map(
                  (suffix) => DropdownMenuItem(
                    value: suffix,
                    child: Text(Lang.t(suffix)),
                  ),
                )
                .toList(),
            onChanged: (val) => onSuffixChanged(val!),
          ),
        ),
      ],
    );
  }
}
