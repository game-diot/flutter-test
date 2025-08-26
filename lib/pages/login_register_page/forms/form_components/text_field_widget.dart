import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
