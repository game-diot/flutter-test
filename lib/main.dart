import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart'; // 新增
import 'package:provider/provider.dart';
import 'providers/language/language.dart';
import 'providers/color/color.dart';


import 'login_register_page/splash_screen.dart';
import 'login_register_page/forms/login_form.dart';
import 'login_register_page/forms/register_form.dart';
import 'home_page/home.dart';
import 'add_page/add.dart';
import 'forum_page/forum.dart';
import 'setting_page/setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保异步初始化
  final savedThemeMode = await AdaptiveTheme.getThemeMode(); // 获取保存的主题模式
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => ChangeColorProvider()),

      ],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      // 亮色主题
      light: ThemeData(
        scaffoldBackgroundColor: Colors.white,

        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
        ),
        cardColor: Colors.white, // 卡片背景
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87), // 文字颜色
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      // 暗色主题
      dark: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212), // 暗黑背景
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
        ),
        cardColor: Color(0xFF1E1E1E), // 卡片背景
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        iconTheme: IconThemeData(color: Colors.white70),
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
