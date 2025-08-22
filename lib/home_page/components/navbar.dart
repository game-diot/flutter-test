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
    final selectedColor = isLight ? Color.fromRGBO(41, 46, 56, 1) : Colors.white;
    final unselectedColor = isLight ? Color.fromRGBO(134, 144, 156, 1) : Colors.grey[400];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: isLight ? Color.fromRGBO(134, 144, 156, 0.4) : Colors.grey[700]!, width: 1),
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
              color: Color.fromRGBO(237, 176, 35, 1), // 中间按钮固定色
            ),
            label: '',
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
      ),
    );
  }
}
