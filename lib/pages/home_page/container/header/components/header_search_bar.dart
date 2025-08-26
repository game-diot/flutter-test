import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class HeaderSearchBar extends StatelessWidget {
  const HeaderSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    final searchBg = isLight ? const Color(0xfff2f2f2) : Colors.grey[800];
    final searchTextColor = isLight ? Colors.black87 : Colors.white70;

    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
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
