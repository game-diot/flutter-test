import 'package:flutter/material.dart';

class DetailPageController {
  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  void showCommentInput(BuildContext context) {
    final isDark = isDarkMode(context);
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        color: isDark ? Colors.grey[850] : Colors.white,
        child: Center(
          child: Text(
            '评论输入框...',
            style: TextStyle(
              color: isDark ? const Color(0xFFDFE5EC) : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
