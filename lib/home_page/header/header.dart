import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late AdaptiveThemeMode _themeMode;
  String _selectedLanguage = "English"; // 默认语言

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
    setState(() {
      _selectedLanguage = language;
    });
    // TODO: 在这里做切换语言逻辑，例如调用国际化方法
    debugPrint("选择的语言: $language");
  }

  @override
  Widget build(BuildContext context) {
    final isLight = _themeMode == AdaptiveThemeMode.light;

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

          // 语言选择按钮（地球图标 + 下拉菜单）
          PopupMenuButton<String>(
            icon: Icon(Icons.public, size: 36, color: publicIconColor),
            onSelected: _onLanguageSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(value: "English", child: Text("English")),
              const PopupMenuItem(value: "日本語", child: Text("日本語")),
              const PopupMenuItem(value: "中文", child: Text("中文")),
              const PopupMenuItem(value: "한국어", child: Text("한국어")),
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
