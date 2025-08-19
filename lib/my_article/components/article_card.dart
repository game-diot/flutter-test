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
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 文章标题
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            SizedBox(height: 8),

            // 用户信息
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 14,
                ),
                SizedBox(width: 8),
                Text(username, style: TextStyle(fontSize: 14)),
              ],
            ),

            SizedBox(height: 8),

            // 内容概览
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),

            SizedBox(height: 12),

            // 底部操作栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up_off_alt, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('$likes'),
                    SizedBox(width: 12),
                    Icon(Icons.comment, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('$comments'),
                  ],
                ),
                GestureDetector(
                  onTap: onMore,
                  child: Text("更多操作", style: TextStyle(color: Colors.blue)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
