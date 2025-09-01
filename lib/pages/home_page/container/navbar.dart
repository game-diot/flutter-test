import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../../../localization/i18n/lang.dart'; // 替换为实际路径
import '../../add_page/add_page.dart';

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
                : Icon(Icons.show_chart_outlined),
            label: Lang.t('market'),
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Icon(Icons.book)
                : Icon(Icons.book_outlined),
            label: Lang.t('news'),
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, 4),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(237, 176, 35, 1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Color.fromRGBO(51, 51, 51, 1),
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? Icon(Icons.chat_bubble, size: 30)
                : Icon(Icons.chat_bubble_outline, size: 30),
            label: Lang.t('forum'),
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 4
                ? Icon(Icons.settings)
                : Icon(Icons.settings_outlined),
            label: Lang.t('setting'),
          ),
        ],
      ),
    );
  }
}
