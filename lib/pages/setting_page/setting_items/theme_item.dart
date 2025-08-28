// components/items/theme_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../components/setting_item.dart';

class ThemeItem extends StatelessWidget {
  const ThemeItem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    String themeSubtitle;
    switch (AdaptiveTheme.of(context).mode) {
      case AdaptiveThemeMode.light:
        themeSubtitle = '明亮';
        break;
      case AdaptiveThemeMode.dark:
        themeSubtitle = '暗黑';
        break;
      case AdaptiveThemeMode.system:
      default:
        themeSubtitle = '跟随系统';
    }

    return SettingItem(
      icon: SvgPicture.asset(
        'assets/svgs/setting_theme.svg',
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
      title: '主题',
      subtitle: themeSubtitle,
      options: const ['明亮', '暗黑', '跟随系统'],
      isArrow: true,
      onSelected: (selected) {
        switch (selected) {
          case '明亮':
            AdaptiveTheme.of(context).setLight();
            break;
          case '暗黑':
            AdaptiveTheme.of(context).setDark();
            break;
          case '跟随系统':
            AdaptiveTheme.of(context).setSystem();
            break;
        }
      },
    );
  }
}
