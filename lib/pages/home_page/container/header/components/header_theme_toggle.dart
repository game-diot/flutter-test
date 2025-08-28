import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class HeaderThemeToggle extends StatelessWidget {
  final bool isLight;
  const HeaderThemeToggle({super.key, required this.isLight});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isLight ? Icons.dark_mode : Icons.light_mode,
          size: 28, color: isLight ? Colors.black : Colors.white),
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
