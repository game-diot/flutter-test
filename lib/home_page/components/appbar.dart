import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;

  const HomeAppBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (currentIndex == 4) {
      // Setting 页面固定深色
      return AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color.fromRGBO(81, 63, 41, 1),
        elevation: 0,
      );
    }

    return AppBar(
      toolbarHeight: 0,
      backgroundColor: isDark
          ? const Color.fromRGBO(18, 18, 18, 1) // 暗色背景
          : const Color.fromRGBO(237, 176, 35, 1), // 明亮背景
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}
