// components/article_card.dart
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String avatarUrl;
  final String username;
  final String content;
  final int likes;
  final int comments;
  final VoidCallback? onMore;

  const ArticleCard({
    Key? key,
    required this.title,
    required this.avatarUrl,
    required this.username,
    required this.content,
    required this.likes,
    required this.comments,
    this.onMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? const Color(0xFFDFE5EC) : Colors.black;
    final subTextColor = isDark
        ? Colors.grey[400]!
        : const Color.fromRGBO(134, 144, 156, 1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1), // 仅下边框
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(12), // 仅下角圆角
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 文章标题
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            // 用户信息
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  username,
                  style: TextStyle(fontSize: 14, color: textColor),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 内容概览
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: subTextColor),
            ),

            const SizedBox(height: 12),

            // 底部操作栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('$likes', style: TextStyle(color: subTextColor)),
                    const SizedBox(width: 4),
                    Text('点赞数', style: TextStyle(color: subTextColor)),

                    const SizedBox(width: 12),
                    Text('$comments', style: TextStyle(color: subTextColor)),
                    const SizedBox(width: 4),
                    Text('评论数', style: TextStyle(color: subTextColor)),
                  ],
                ),
                GestureDetector(
                  onTap: onMore,
                  child: Text(
                    "...",
                    style: TextStyle(color: subTextColor, fontSize: 24),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
