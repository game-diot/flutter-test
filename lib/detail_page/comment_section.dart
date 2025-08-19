import 'package:flutter/material.dart';
import 'components/detail_comment_item.dart';


class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        const DetailCommentItem(
          avatarUrl: 'https://example.com/avatar1.jpg',
          username: '评论者A',
          content: '非常有帮助的内容！',
          time: '2小时前',
          likeCount: 3,
        ),
        const DetailCommentItem(
          avatarUrl: 'https://example.com/avatar2.jpg',
          username: '评论者B',
          content: '学习到了，谢谢分享。',
          time: '昨天',
          likeCount: 5,
        ),
      ],
    );
  }
}
