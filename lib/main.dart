import 'package:flutter/material.dart';
import 'splash_screen_page/splash_screen.dart';
import 'forms/login_form.dart';
import 'forms/register_form.dart';
import 'home_page/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginForm(),
        '/register': (context) => RegisterForm(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
