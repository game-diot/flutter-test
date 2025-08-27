import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../../add_page/add.dart';

class Navbar extends StatelessWidget {
  final ValueChanged<int> onTabSelected;
  final int currentIndex;

  Navbar({required this.onTabSelected, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;

    final backgroundColor = isLight ? Colors.white : Color(0xFF1E1E1E);
    final selectedColor = isLight
        ? Color.fromRGBO(41, 46, 56, 1)
        : Colors.white;
    final unselectedColor = isLight
        ? Color.fromRGBO(134, 144, 156, 1)
        : Colors.grey[400];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isLight
                ? Color.fromRGBO(134, 144, 156, 0.4)
                : Colors.grey[700]!,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPage()),
            );
          } else {
            onTabSelected(index);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? Icon(Icons.show_chart)
                : Icon(Icons.show_chart_outlined), // 未选中轮廓
            label: '行情',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Icon(Icons.book)
                : Icon(Icons.book_outlined),
            label: '新闻',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromRGBO(237, 176, 35, 1), // 背景黑色
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 30,
                color: Color.fromRGBO(51,51,51, 1), // 图标黄色
              ),
            ),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? Icon(Icons.chat_bubble, size: 30) // 选中实心气泡
                : Icon(Icons.chat_bubble_outline, size: 30), // 未选中轮廓气泡
            label: '论坛',
          ),

          BottomNavigationBarItem(
            icon: currentIndex == 4
                ? Icon(Icons.settings)
                : Icon(Icons.settings_outlined),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
