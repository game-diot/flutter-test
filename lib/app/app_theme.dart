import 'package:flutter/material.dart';

class AppTheme {
  // ⚠️ 风险: 浅色主题 AppBar 没设置 backgroundColor，可能出现白字白底
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue, // ✅ 建议显式设置
      foregroundColor: Colors.white,
    ),
    cardColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
    ),
    cardColor: const Color(0xFF1E1E1E),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
  );
}
