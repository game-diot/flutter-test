import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../../providers/language/language.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late AdaptiveThemeMode _themeMode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeMode = AdaptiveTheme.of(context).mode;
  }

  void _toggleTheme() {
    final adaptiveTheme = AdaptiveTheme.of(context);
    if (_themeMode == AdaptiveThemeMode.light) {
      adaptiveTheme.setDark();
      setState(() => _themeMode = AdaptiveThemeMode.dark);
    } else {
      adaptiveTheme.setLight();
      setState(() => _themeMode = AdaptiveThemeMode.light);
    }
  }

  void _onLanguageSelected(String language) {
    context.read<LanguageProvider>().setLanguage(language);
    debugPrint("选择的语言: $language");
  }

  @override
  Widget build(BuildContext context) {
    final isLight = _themeMode == AdaptiveThemeMode.light;
    final currentLang = context.watch<LanguageProvider>().language;

    // 颜色适配
    final avatarBg = isLight ? Colors.white : Colors.grey[850];
    final avatarIconColor =
        isLight ? const Color.fromRGBO(237, 176, 35, 1) : Colors.orangeAccent;
    final searchBg = isLight ? const Color(0xfff2f2f2) : Colors.grey[800];
    final searchTextColor = isLight ? Colors.black87 : Colors.white70;
    final publicIconColor = isLight ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16),

          // 用户头像
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarBg,
            child: Icon(
              Icons.person,
              size: 30,
              color: avatarIconColor,
            ),
          ),
          const SizedBox(width: 20),

          // 搜索框
          Container(
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
          ),
          const SizedBox(width: 20),

          // 语言选择按钮（带高亮）
          PopupMenuButton<String>(
            icon: Icon(Icons.public, size: 36, color: publicIconColor),
            initialValue: currentLang,
            onSelected: _onLanguageSelected,
            itemBuilder: (context) => [
              for (var lang in ["English", "日本語", "中文", "한국어"])
                PopupMenuItem(
                  value: lang,
                  child: Row(
                    children: [
                      if (lang == currentLang) ...[
                        const Icon(Icons.check, size: 18, color: Colors.blue),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        lang,
                        style: TextStyle(
                          fontWeight: lang == currentLang
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),

          // 主题切换按钮
          IconButton(
            icon: Icon(
              isLight ? Icons.dark_mode : Icons.light_mode,
              size: 36,
              color: isLight ? Colors.black : Colors.white,
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
    );
  }
}
