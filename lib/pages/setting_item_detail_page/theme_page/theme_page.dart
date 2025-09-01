import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'theme_option.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  int selectedIndex = 0; // 0: light, 1: dark
  bool _initialized = false; // 避免重复执行

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final mode = AdaptiveTheme.of(context).mode;
      if (mode == AdaptiveThemeMode.light) {
        selectedIndex = 0;
      } else if (mode == AdaptiveThemeMode.dark) {
        selectedIndex = 1;
      } else {
        selectedIndex = 0; // 默认亮色
      }
      _initialized = true;
    }
  }

  void _setTheme(int index) {
    setState(() => selectedIndex = index);
    switch (index) {
      case 0:
        AdaptiveTheme.of(context).setLight();
        break;
      case 1:
        AdaptiveTheme.of(context).setDark();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("主题切换"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        foregroundColor:
            theme.appBarTheme.foregroundColor ??
            theme.textTheme.titleLarge?.color,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("选择应用主题风格（浅色或深色）", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ThemeOption(
                  index: 0,
                  imagePath: 'assets/images/light.png',
                  isSelected: selectedIndex == 0,
                  onTap: () => _setTheme(0),
                ),
                ThemeOption(
                  index: 1,
                  imagePath: 'assets/images/dark.png',
                  isSelected: selectedIndex == 1,
                  onTap: () => _setTheme(1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
