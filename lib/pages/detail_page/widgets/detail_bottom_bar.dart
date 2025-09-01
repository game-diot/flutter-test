import 'package:flutter/material.dart';

class DetailBottomBar extends StatelessWidget {
  final VoidCallback onCommentTap;
  final int starCount;
  final int likeCount;
  final int commentCount;

  const DetailBottomBar({
    super.key,
    required this.onCommentTap,
    this.starCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  Widget _buildIconWithText(IconData icon, int count, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 2),
        Text('$count', style: TextStyle(fontSize: 10, color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final inputBgColor = isDark ? Colors.grey[800] : const Color(0xFFF0F0F0);
    final textColor = isDark ? Colors.white70 : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[700]! : const Color(0xFFEEEEEE),
          ),
        ),
        color: bgColor,
      ),
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onCommentTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: inputBgColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text('我来评论', style: TextStyle(color: textColor)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildIconWithText(Icons.star_border, starCount, textColor),
          const SizedBox(width: 16),
          _buildIconWithText(Icons.thumb_up_off_alt, likeCount, textColor),
          const SizedBox(width: 16),
          _buildIconWithText(
            Icons.chat_bubble_outline,
            commentCount,
            textColor,
          ),
        ],
      ),
    );
  }
}
