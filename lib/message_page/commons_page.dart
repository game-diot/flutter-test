import 'package:flutter/material.dart';
import '../my_article/components/common_header.dart';
import 'components/interactionitem.dart';

class CommentedPage extends StatelessWidget {
  const CommentedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentList = [
      {
        "avatar": "https://i.pravatar.cc/150?img=3",
        "username": "王五",
        "actionText": "评论了你的帖子",
        "content": "很棒的帖子！",
        "time": "2025-08-17",
        "isComment": true,
        "likeCount": 2,
      },
      {
        "avatar": "https://i.pravatar.cc/150?img=4",
        "username": "赵六",
        "actionText": "回复了你的评论",
        "content": "你说的很有道理！",
        "time": "2025-08-16",
        "isComment": true,
        "likeCount": 3,
      },
    ];

    return Scaffold(
     appBar: const PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: CommonHeader(title: "被评论信息"),
  ),
      body: Container(  
        // 关键：不要写死颜色，改成主题色
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
        itemCount: commentList.length,
        itemBuilder: (context, index) {
          final item = commentList[index];
          final isComment = item["isComment"] as bool? ?? false;

          return InteractionItem(
            avatarUrl: item["avatar"] as String,
            username: item["username"] as String,
            actionText: item["actionText"] as String,
            content: item["content"] as String,
            time: item["time"] as String,
            isComment: isComment,
            likeCount: item["likeCount"] as int,
          );
        },
      ),
      ),
    );
  }
}
