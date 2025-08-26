// components/common_header.dart
import 'package:flutter/material.dart';
class CommonHeader extends StatelessWidget {
  final String title;

  const CommonHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        color: isDark ? Colors.white : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: isDark ? const Color(0xFFDFE5EC) : Colors.black, // ✅ 和上面统一
        ),
      ),
      centerTitle: true,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      elevation: 0,
      foregroundColor: isDark ? Colors.white : Colors.black,
    );
  }
}
