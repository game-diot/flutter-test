import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class HeaderAvatar extends StatelessWidget {
  const HeaderAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    final avatarBg = isLight ? Colors.white : Colors.grey[850];
    final avatarIconColor = isLight ? const Color.fromRGBO(237, 176, 35, 1) : Colors.orangeAccent;

    return CircleAvatar(
      radius: 20,
      backgroundColor: avatarBg,
      child: Icon(Icons.person, size: 30, color: avatarIconColor),
    );
  }
}
