import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  AdaptiveThemeMode? _themeMode;

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

  @override
  Widget build(BuildContext context) {
    final isLight = _themeMode == AdaptiveThemeMode.light;

    return Row(
      children: [
        const SizedBox(width: 16),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            size: 30,
            color: Color.fromRGBO(237, 176, 35, 1),
          ),
        ),
        const SizedBox(width: 20),
        // 固定颜色输入框
        Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color(0xfff2f2f2), // 固定背景色
          ),
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 5), // 向下偏移 2px
                child: Icon(Icons.search, color: Colors.grey, size: 26),
              ),
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
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
        const Icon(Icons.public, size: 36),
        const SizedBox(width: 16),
        IconButton(
          icon: Icon(
            isLight ? Icons.dark_mode : Icons.light_mode, // 切换图标
            size: 36,
          ),
          onPressed: _toggleTheme,
        ),
      ],
    );
  }
}
