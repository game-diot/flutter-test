import 'package:flutter/material.dart';
import '../../../../localization/i18n/lang.dart'; // 替换为你的实际路径

class LoginRegisterButton extends StatelessWidget {
  final VoidCallback? onSwitchToRegister;

  const LoginRegisterButton({Key? key, this.onSwitchToRegister})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onSwitchToRegister,
        child: Text(Lang.t('register'), style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          elevation: 0, // 去掉阴影
          backgroundColor: const Color.fromRGBO(244, 244, 245, 1),
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
