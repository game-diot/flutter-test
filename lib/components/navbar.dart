import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final ValueChanged<int> onTabSelected;
  final int currentIndex;

  Navbar({required this.onTabSelected, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // 使用固定类型
      onTap: onTabSelected, // 触发选中的回调
      currentIndex: currentIndex, // 使用传入的当前索引
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart), // 行情图标
          label: '行情', // 非空标签
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book), // 新闻图标
          label: '新闻', // 非空标签
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 50), // 加号图标
          label: '', // 非空标签
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud), // 论坛图标（调整大小）
          label: '论坛', // 非空标签
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings), // 设置图标
          label: '设置', // 非空标签
        ),
      ],
    );
  }
}
