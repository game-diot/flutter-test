import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class HeaderSearchBar extends StatelessWidget {
  const HeaderSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    final searchBg = isLight ? const Color.fromRGBO(242, 242, 242, 1) :Color.fromRGBO(242, 242, 242, 1);
    final searchTextColor = isLight ? Colors.black87 : Colors.white70;

    return Container(
      width: 230,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: searchBg,
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.search, color: Colors.grey, size: 26),
          ),
          Expanded(
            child: TextField(
              style: TextStyle(color: searchTextColor),
              decoration: const InputDecoration(
                hintText: '搜索币对',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
