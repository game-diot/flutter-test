import 'package:flutter/material.dart';
import '../../../../localization/lang.dart'; // 引入翻译包

class LoginEmailInput extends StatelessWidget {
  final TextEditingController controller;
  final String selectedSuffix;
  final ValueChanged<String> onSuffixChanged;

  const LoginEmailInput({
    Key? key,
    required this.controller,
    required this.selectedSuffix,
    required this.onSuffixChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: Lang.t('enter_email'),
              hintStyle: const TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(244, 244, 244, 1),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(244, 244, 244, 1),
                  width: 1,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            value: selectedSuffix,
            isExpanded: true,
            underline: const SizedBox(),
            items: ["@qq.com", "@163.com", "@gmail.com"]
                .map(
                  (suffix) => DropdownMenuItem(
                    value: suffix,
                    child: Text(
                      Lang.t(suffix),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              if (value != null) {
                onSuffixChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
