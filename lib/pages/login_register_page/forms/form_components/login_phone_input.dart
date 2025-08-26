import 'package:flutter/material.dart';
import '../../../../network/Get/models/splash_page/login_area.dart';
import 'login_form_country_widget.dart';

class LoginPhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<Country> onCountrySelected;

  const LoginPhoneInput({
    Key? key,
    required this.controller,
    required this.onCountrySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: CountrySelectWidget(onSelected: onCountrySelected),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: '请输入手机号',
              hintStyle: const TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}
