import 'package:flutter/material.dart';

class RowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: Color.fromARGB(255, 63, 61, 51),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 保证组件之间间隔均匀
        children: [
          // 书本图标
          Icon(Icons.book, size: 26, color: Color.fromRGBO(237, 176, 35, 1)),

          // 文字描述
          Text(
            '立即查看最新资讯',
            style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.w500),
          ),

          // 右箭头
          Icon(Icons.arrow_forward, size: 26, color: Color.fromRGBO(237, 176, 35, 1)),
        ],
      ),
    );
  }
}
