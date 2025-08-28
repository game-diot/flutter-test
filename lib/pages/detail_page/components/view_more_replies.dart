// lib/forum/widgets/view_more_replies.dart
import 'package:flutter/material.dart';
import 'comment_item.dart';
import 'comment_model.dart';

class ViewMoreReplies extends StatelessWidget {
  final CommentModel comment;
  const ViewMoreReplies({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 66, right: 16, bottom: 8),
      child: GestureDetector(
        onTap: () => _showMoreReplies(context),
        child: Row(
          children: [
            const Text('展开', style: TextStyle(fontSize: 12, color: Color.fromRGBO(237, 176, 35, 1))),
            const SizedBox(width: 4),
            Text('${comment.hiddenRepliesCount} 条回复', style: const TextStyle(fontSize: 12, color: Color.fromRGBO(237, 176, 35, 1))),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 14, color: Color.fromRGBO(237, 176, 35, 1)),
          ],
        ),
      ),
    );
  }

  void _showMoreReplies(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('全部回复', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: comment.hiddenRepliesCount + comment.replies.length,
                  itemBuilder: (context, index) {
                    if (index < comment.replies.length) {
                      return CommentItem(comment: comment.replies[index], isReply: true);
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: CommentItem(
                          comment: CommentModel(
                            id: 'more-${index}',
                            avatarUrl: 'https://i.pravatar.cc/150?img=${index + 10}',
                            username: '用户${index}',
                            content: '这是更多的回复内容...',
                            time: '12:0${index}',
                            likeCount: index,
                          ),
                          isReply: true,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
