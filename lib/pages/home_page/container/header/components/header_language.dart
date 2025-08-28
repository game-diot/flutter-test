import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/language/language.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderLanguage extends StatelessWidget {
  const HeaderLanguage({super.key});

  void _onLanguageSelected(BuildContext context, String language) {
    context.read<LanguageProvider>().setLanguage(language);
    debugPrint("选择的语言: $language");
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = context.watch<LanguageProvider>().language;
    // 根据主题设置图标颜色
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return PopupMenuButton<String>(
      icon: SvgPicture.asset(
        'assets/svgs/earth.svg',
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
      initialValue: currentLang,
      onSelected: (lang) => _onLanguageSelected(context, lang),
      itemBuilder: (context) => [
        for (var lang in ["English", "日本語", "中文", "한국어"])
          PopupMenuItem(
            value: lang,
            child: Row(
              children: [
                if (lang == currentLang) ...[
                  const Icon(Icons.check, size: 18, color: Colors.blue),
                  const SizedBox(width: 4),
                ],
                Text(
                  lang,
                  style: TextStyle(
                    fontWeight: lang == currentLang ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
