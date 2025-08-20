import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart'; // 新增

import 'splash_screen_page/splash_screen.dart';
import 'forms/login_form.dart';
import 'forms/register_form.dart';
import 'home_page/home.dart';
import 'add_page/add.dart';
import 'forum_page/forum.dart';
import 'setting_page/setting.dart';
import 'detail_page/detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保异步初始化
  final savedThemeMode = await AdaptiveTheme.getThemeMode(); // 获取保存的主题模式
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // 设置背景为白色
      ),
      dark: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.white, // 暗黑模式也设置为白色
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        darkTheme: darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginForm(),
          '/register': (context) => RegisterForm(),
          '/home': (context) => HomePage(),
          '/add': (context) => AddPage(),
          '/forum': (context) => ForumPage(),
          '/setting': (context) => SettingPage(),
        },
      ),
    );
  }
}
