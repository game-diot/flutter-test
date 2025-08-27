import 'package:flutter/material.dart';

class LoginAgreement extends StatelessWidget {
  const LoginAgreement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // 保证垂直居中
      children: [
        const Text('登录即表示同意', style: TextStyle(color: Colors.black)),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero, // 去掉默认左右 padding
            minimumSize: Size(0, 0), // 避免撑开
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 点击区域紧凑
          ),
          child: const Text('使用协议', style: TextStyle(color: Color(0xFFedb023))),
        ),
        const Text('/'),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('隐私协议', style: TextStyle(color: Color(0xFFedb023))),
        ),
      ],
    );
  }
}
