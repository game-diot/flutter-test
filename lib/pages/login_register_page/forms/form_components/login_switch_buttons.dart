import 'package:flutter/material.dart';

class LoginSwitchButtons extends StatelessWidget {
  final bool isPhoneSelected;
  final ValueChanged<bool> onSwitch;

  const LoginSwitchButtons({
    Key? key,
    required this.isPhoneSelected,
    required this.onSwitch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => onSwitch(true),
            child: const Text('手机号'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isPhoneSelected ? const Color(0xFFf4f4f5) : Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onSwitch(false),
            child: const Text('邮箱'),
            style: ElevatedButton.styleFrom(
              backgroundColor: !isPhoneSelected ? const Color(0xFFf4f4f5) : Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
