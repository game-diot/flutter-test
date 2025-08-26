import 'package:flutter/material.dart';

class LoginAgreement extends StatelessWidget {
  const LoginAgreement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        const Text('登录即表示同意', style: TextStyle(color: Colors.black)),
        TextButton(
          onPressed: () {},
          child: const Text('使用协议', style: TextStyle(color: Color(0xFFedb023))),
        ),
        const Text('/'),
        TextButton(
          onPressed: () {},
          child: const Text('隐私协议', style: TextStyle(color: Color(0xFFedb023))),
        ),
      ],
    );
  }
}
