import 'package:flutter/material.dart';
import '../add_page/add.dart'; // 引入添加页

class Navbar extends StatelessWidget {
  final ValueChanged<int> onTabSelected;
  final int currentIndex;

  Navbar({required this.onTabSelected, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 2) {
          // 中间加号点击，跳转到 AddPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
        } else {
          onTabSelected(index); // 调用外部回调改变页面
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: '行情',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: '新闻',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle,
            size: 50,
            color: Color.fromRGBO(237, 176, 35, 1),
          ),
          label: '', // 保持中间按钮无文字
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud, size: 30),
          label: '论坛',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '设置',
        ),
      ],
    );
  }
}
