import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  const CommonHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          color: isDark ? const Color(0xFFDFE5EC) : Colors.black,
        ),
      ),
      centerTitle: true,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      elevation: 0,
    );
  }
}
