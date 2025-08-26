import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'app_theme.dart';
import 'app_routes.dart';

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        darkTheme: darkTheme,
        initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.routes,
      ),
    );
  }
}
