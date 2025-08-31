import 'package:flutter/material.dart';
import 'country_widget.dart';
import '../../../../localization/i18n/lang.dart';
import '../../../../network/Get/models/splash_page/login_area.dart';

class RegisterPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<Country> onCountrySelected;

  const RegisterPhoneField({
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
        hintText: Lang.t('enter_phone'),
        hintStyle: const TextStyle(color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
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
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
