import 'package:flutter/material.dart';
import 'home_page/home.dart'; // 引入 HomePage
import 'splash_screen_page/splash_screen.dart'; // 引入 SplashScreen
import 'news_page/news.dart'; // 引入 NewsPage
import 'forum_page/forum.dart'; // 引入 ForumPage
import 'add_page/add.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     initialRoute: '/', // 设置初始路由
      routes: {
        '/': (context) => SplashScreen(), // 路由映射，加载启动页
        '/home': (context) => AddPage(), // 路由映射，加载主页
        '/forum': (context) => ForumPage(), // 路由映射，加载论坛页面
        '/add': (context) => AddPage(), // 路由映射，加载添加页面
        '/news': (context) => NewsPage(), // 路由映射，加载新闻页面
      },
    );
  }
}
