// pages/liked_page.dart
import 'package:flutter/material.dart';
import 'components/interactionitem.dart';
import '../my_article/components/common_header.dart';

class LikedPage extends StatelessWidget {
  const LikedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likedList = [
      {
        "avatar": "https://i.pravatar.cc/150?img=1",
        "username": "张三",
        "actionText": "点赞了你的帖子",
        "content": "这是一篇测试帖子内容",
        "time": "2025-08-19",
        "isComment": false,
      },
      {
        "avatar": "https://i.pravatar.cc/150?img=2",
        "username": "李四",
        "actionText": "点赞了你的评论",
        "content": "你在帖子里的评论内容",
        "time": "2025-08-18",
        "isComment": false,
        "likeCount": 5,
      },
    ];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CommonHeader(title: "获赞信息"),
      ),
      body: Container(
        // 关键：不要写死颜色，改成主题色
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          itemCount: likedList.length,
          itemBuilder: (context, index) {
            final item = likedList[index];
            final isComment = item["isComment"] as bool? ?? false;

            return InteractionItem(
              avatarUrl: item["avatar"] as String,
              username: item["username"] as String,
              actionText: item["actionText"] as String,
              content: item["content"] as String,
              time: item["time"] as String,
              isComment: isComment,
              likeCount: item["likeCount"] as int?,
            );
          },
        ),
      ),
    );
  }
}
