//具体文章页面为实现，后端数据实现动态路由
import 'package:flutter/material.dart';
import '../pages/login_register_page/forms/login_form.dart';
import '../pages/login_register_page/forms/register_form.dart';
import '../pages/add_page/add_page.dart';
import '../pages/forum_page/forum.dart';
import '../pages/home_page/home.dart';
import '../pages/login_register_page/splash_screen.dart';
import '../pages/message_page/commons_page.dart';
import '../pages/message_page/likes_page.dart';
import '../pages/my_article/my_likes_page.dart';
import '../pages/my_article/my_post_page.dart';
import '../pages/news_page/news.dart';
import '../pages/setting_page/setting.dart';

class AppRoutes {
  static const String initialRoute = '/';

  static final Map<String, WidgetBuilder> routes = {
    '/': (_) => SplashScreen(),
    '/login': (_) => LoginForm(),
    '/register': (_) => RegisterForm(),
    '/home': (_) => HomePage(),
    '/add': (_) => AddPage(),
    '/forum': (_) => ForumPage(),
    '/setting': (_) => SettingPage(),
    '/news': (_) => NewsPage(),
    '/myarticle/mylikes': (_) => MyLikesPage(),
    '/myarticle/myposts': (_) => MyPostsPage(),
    '/message/commented': (_) => CommentedPage(),
    '/message/liked': (_) => LikedPage(),
  };
}
