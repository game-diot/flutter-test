import 'package:flutter/material.dart';
import '../../../localization/i18n/lang.dart'; // 替换为实际路径

class AuthButtons extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const AuthButtons({Key? key, required this.onLogin, required this.onRegister})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 24,
      right: 24,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onLogin,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 65),
              backgroundColor: const Color(0xFF292e38),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(Lang.t('login')),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRegister,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 65),
              backgroundColor: const Color(0xFFedb023),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide.none,
              ),
              elevation: 0,
            ),
            child: Text(Lang.t('register')),
          ),
        ],
      ),
    );
  }
}
