import 'package:flutter/material.dart';

class LoginRegisterButton extends StatelessWidget {
  final VoidCallback? onSwitchToRegister;

  const LoginRegisterButton({Key? key, this.onSwitchToRegister}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSwitchToRegister,
      child: const Text(
        '没有账号？去注册',
        style: TextStyle(color: Color(0xFFedb023), fontSize: 18),
      ),
    );
  }
}
