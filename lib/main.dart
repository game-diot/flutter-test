import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import 'providers/language/language.dart';
import 'providers/color/color.dart';
import 'providers/exchange/exchange.dart';
import 'providers/countries/countries.dart';
import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ChangeColorProvider()),
        ChangeNotifierProvider(create: (_) => ExchangeRateProvider()),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
      ],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}
