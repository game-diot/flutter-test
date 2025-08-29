import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'app_routes.dart';
import '../providers/countries/countries.dart';

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // App启动后立即加载国家数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CountryProvider>().loadCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          darkTheme: darkTheme,
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.routes,
          builder: (context, child) {
            // 可选：在这里统一包裹 Provider 或其他全局功能
            return child!;
          },
        );
      },
    );
  }
}
