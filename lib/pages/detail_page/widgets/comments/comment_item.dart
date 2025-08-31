import 'package:flutter/material.dart';
import 'comment_model.dart';
import 'view_more_replies.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final bool isReply;

  const CommentItem({super.key, required this.comment, this.isReply = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCommentContent(context),
        // 子回复
        if (comment.replies.isNotEmpty)
          ...comment.replies.map(
            (reply) => Padding(
              padding: const EdgeInsets.only(left: 50),
              child: CommentItem(comment: reply, isReply: true),
            ),
          ),
        // 展示更多回复
        if (comment.hasMoreReplies) ViewMoreReplies(comment: comment),
      ],
    );
  }

  Widget _buildCommentContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: isReply ? 8 : 12,
        bottom: isReply ? 8 : 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(comment.avatarUrl),
            radius: isReply ? 16 : 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.username,
                  style: const TextStyle(
                    color: Color.fromRGBO(134, 144, 156, 1),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: TextStyle(fontSize: isReply ? 13 : 14),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      comment.time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _showReplyDialog(context),
                      child: const Text(
                        '回复',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  size: isReply ? 18 : 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${comment.likeCount}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '回复评论',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: '回复 ${comment.username}...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('发送'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
