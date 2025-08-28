// components/items/language_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/language/language.dart';
import '../components/setting_item.dart';

class LanguageItem extends StatelessWidget {
  const LanguageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final iconColor = isDark ? Colors.white : Colors.black;

        return SettingItem(
          icon: SvgPicture.asset(
            'assets/svgs/earth.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          title: '切换语言',
          subtitle: languageProvider.language,
          options: const ['中文', 'English', '日本語', '한국어'],
          isArrow: true,
          onSelected: languageProvider.setLanguage,
        );
      },
    );
  }
}
