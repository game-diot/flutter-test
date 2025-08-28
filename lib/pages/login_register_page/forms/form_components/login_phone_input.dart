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
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: '请输入手机号',
        hintStyle: const TextStyle(color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color.fromRGBO(244, 244, 244, 1), // 纯淡灰色
            width: 1, // 比较细，但能看到
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color.fromRGBO(244, 244, 244, 1),
            width: 1,
          ),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min, // 不撑满
            children: [
              SizedBox(
                width: 80,
                child: CountrySelectWidget(onSelected: onCountrySelected),
              ),
              const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
            ],
          ),
        ),
       
      ),
      keyboardType: TextInputType.phone,
    );
  }
}
