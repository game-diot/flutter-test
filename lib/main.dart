import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import 'providers/language/language.dart';
import 'providers/color/color.dart';
import 'providers/exchange/exchange.dart';
import 'providers/countries/countries.dart';
import 'providers/login/login.dart';       // 你的 AuthProvider
import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 获取保存的主题模式
  final savedThemeMode = await AdaptiveTheme.getThemeMode();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ChangeColorProvider()),
        ChangeNotifierProvider(create: (_) => ExchangeRateProvider()),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
         ChangeNotifierProvider(create: (_) => AuthProvider()), // 注入登录状态 Provider
      ],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}
