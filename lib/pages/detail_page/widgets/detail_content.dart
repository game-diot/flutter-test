import 'package:flutter/material.dart';

class DetailContent extends StatelessWidget {
  final String content;
  const DetailContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
