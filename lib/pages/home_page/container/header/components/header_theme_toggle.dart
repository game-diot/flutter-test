import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class HeaderThemeToggle extends StatelessWidget {
  final bool isLight;
  const HeaderThemeToggle({super.key, required this.isLight});

  @override
  Widget build(BuildContext context) {
    // 根据主题设置颜色
    final iconColor = isLight ? Colors.black : Colors.white;

    return IconButton(
      icon: SvgPicture.asset(
        'assets/svgs/theme.svg', // SVG 路径
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
      onPressed: () {
        final adaptiveTheme = AdaptiveTheme.of(context);
        if (isLight) {
          adaptiveTheme.setDark();
        } else {
          adaptiveTheme.setLight();
        }
      },
    );
  }
}
