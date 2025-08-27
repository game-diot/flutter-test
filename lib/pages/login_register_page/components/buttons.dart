import 'package:flutter/material.dart';

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
            child: const Text('登录'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRegister,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 65),
              backgroundColor: const Color(0xFFedb023),
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide.none, // 去掉边框
              ),
              elevation: 0, // 去掉阴影
            ),
            child: const Text('注册'),
          ),
        ],
      ),
    );
  }
}
