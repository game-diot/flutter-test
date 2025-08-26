import 'package:flutter/material.dart';
import '../container/forumpostblock.dart';

class ForumPostList extends StatelessWidget {
  const ForumPostList({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        "title": "区块链最新动态",
        "author": "张三",
        "content": "今天区块链又有新的发展趋势，需要关注市场变化...",
        "likes": 12,
        "comments": 3,
      },
      {
        "title": "心得分享：Flutter布局经验",
        "author": "李四",
        "content": "在实际开发中，使用Row+Column可以更好地处理复杂布局...",
        "likes": 8,
        "comments": 2,
      },
    ];

    return Column(
      children: List.generate(posts.length, (i) {
        final post = posts[i];
        return ForumPostBlock(
          title: post["title"] as String,
          author: post["author"] as String,
          content: post["content"] as String,
          likes: post["likes"] as int,
          comments: post["comments"] as int,
          rank: i + 1,
        );
      }),
    );
  }
}
