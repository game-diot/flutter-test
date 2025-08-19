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

  Widget _buildIconWithText(IconData icon, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(height: 2),
        Text(
          '$count',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        color: Colors.white,
      ),
      height: 100,
      child: Container(
      child: Row(
        children: [
          // 左侧输入框点击区域
          Expanded(
            child: GestureDetector(
              onTap: onCommentTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  '我来评论',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 右侧图标栏
          _buildIconWithText(Icons.star_border, starCount),
          const SizedBox(width: 16),
          _buildIconWithText(Icons.thumb_up_off_alt, likeCount),
          const SizedBox(width: 16),
          _buildIconWithText(Icons.chat_bubble_outline, commentCount),
        ],
      ),
    ),
    );
  }
}
