import 'package:flutter/material.dart';

class RowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 保证组件之间间隔均匀
        children: [
          // 书本图标
          Icon(Icons.book, size: 30, color: Colors.blue),

          // 文字描述
          Text(
            '阅读更多',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),

          // 右箭头
          Icon(Icons.arrow_forward, size: 30, color: Colors.blue),
        ],
      ),
    );
  }
}
