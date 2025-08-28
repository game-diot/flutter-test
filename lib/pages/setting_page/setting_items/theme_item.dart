// components/items/theme_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/setting_item.dart';
import '../../setting_item_detail_page/change_theme_deatil_page/theme_page.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class ThemeItem extends StatelessWidget {
  const ThemeItem({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 Builder 每次 build 时获取最新 AdaptiveTheme
    return Builder(
      builder: (context) {
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
          isArrow: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ThemePage()),
            ).then((_) {
              // 页面返回后刷新
              (context as Element).markNeedsBuild();
            });
          },
        );
      },
    );
  }
}
