// lib/forum/widgets/comment_section.dart
import 'package:flutter/material.dart';
import 'comment_model.dart';
import 'comment_item.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CommentModel> comments = [
      // 这里模拟数据
      CommentModel(
        id: '1',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        username: '小王',
        content: '给外公外公我不玩...',
        time: '12:02',
        likeCount: 7,
        replies: [
          CommentModel(
            id: '1-1',
            avatarUrl: 'https://i.pravatar.cc/150?img=2',
            username: '星星之火',
            content: '给外公外公我不玩...',
            time: '12:02',
            likeCount: 5,
          ),
        ],
      ),
      // 可以添加更多
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '全部回复',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ...comments.map((comment) => CommentItem(comment: comment)),
      ],
    );
  }
}
