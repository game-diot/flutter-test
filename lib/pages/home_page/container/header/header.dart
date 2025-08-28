import 'package:flutter/material.dart';
import 'components/header_avatar.dart';
import 'components/header_search_bar.dart';
import 'components/header_language.dart';
import 'components/header_theme_toggle.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Row(
        children: [
          const HeaderAvatar(),
          const SizedBox(width: 4),
          const HeaderSearchBar(),
          const SizedBox(width: 10),
          HeaderLanguage(),
          const SizedBox(width: 0),
          HeaderThemeToggle(isLight: isLight),
        ],
      ),
    );
  }
}
