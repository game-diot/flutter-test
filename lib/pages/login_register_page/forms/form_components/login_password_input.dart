import 'package:flutter/material.dart';

class LoginPasswordInput extends StatelessWidget {
  final TextEditingController controller;

  const LoginPasswordInput({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: '请输入密码',
        hintStyle: const TextStyle(color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
        ),)
    );
  }
}
