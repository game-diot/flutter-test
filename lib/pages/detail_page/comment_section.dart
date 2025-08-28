import 'package:flutter/material.dart';

// 评论数据模型
class CommentModel {
  final String id;
  final String avatarUrl;
  final String username;
  final String content;
  final String time;
  final int likeCount;
  final List<CommentModel> replies;
  final bool hasMoreReplies;
  final int hiddenRepliesCount;

  const CommentModel({
    required this.id,
    required this.avatarUrl,
    required this.username,
    required this.content,
    required this.time,
    required this.likeCount,
    this.replies = const [],
    this.hasMoreReplies = false,
    this.hiddenRepliesCount = 0,
  });
}

// 主评论区组件
class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 模拟评论数据
    final List<CommentModel> comments = [
      CommentModel(
        id: '1',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        username: '小王',
        content: '给外公外公我不玩，不完全圆粉圆，不闻不问去不是我。外公去',
        time: '12:02',
        likeCount: 7,
        replies: [
          CommentModel(
            id: '1-1',
            avatarUrl: 'https://i.pravatar.cc/150?img=2',
            username: '星星之火',
            content: '给外公外公我不玩，不完全圆粉圆，不闻不问去不是我。外公去',
            time: '12:02',
            likeCount: 5,
          ),
        ],
      ),
      CommentModel(
        id: '2',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        username: '小李',
        content: '给外公外公我不玩，不完全圆粉圆，不闻不问去不是我。外公去',
        time: '12:02',
        likeCount: 7,
      ),
      CommentModel(
        id: '3',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        username: '小李',
        content: '给外公外公我不玩，不完全圆粉圆，不闻不问去不是我。外公去',
        time: '12:02',
        likeCount: 7,
        replies: [
          CommentModel(
            id: '3-1',
            avatarUrl: 'https://i.pravatar.cc/150?img=5',
            username: '星星之火',
            content: '给外公外公我不玩，不完全圆粉圆，不闻不问去不是我。外公去',
            time: '12:02',
            likeCount: 8,
          ),
        ],
        hasMoreReplies: true,
        hiddenRepliesCount: 3,
      ),
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

// 单个评论项组件
class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final bool isReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 主评论
        _buildCommentContent(context),
        
        // 子评论（回复）
        if (comment.replies.isNotEmpty)
          ...comment.replies.map((reply) => 
            Padding(
              padding: const EdgeInsets.only(left: 50), // 缩进
              child: CommentItem(comment: reply, isReply: true),
            ),
          ),
        
        // 查看更多回复按钮
        if (comment.hasMoreReplies)
          _buildViewMoreReplies(context),
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
          // 头像
          CircleAvatar(
            backgroundImage: NetworkImage(comment.avatarUrl),
            radius: isReply ? 16 : 20, // 回复的头像稍小
          ),
          const SizedBox(width: 10),

          // 中间内容
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
                  style: TextStyle(
                    fontSize: isReply ? 13 : 14,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      comment.time,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        _showReplyDialog(context);
                      },
                      child: const Text(
                        '回复',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 右侧点赞
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  // 点赞逻辑
                },
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  size: isReply ? 18 : 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${comment.likeCount}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewMoreReplies(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 66, right: 16, bottom: 8),
      child: GestureDetector(
        onTap: () {
          _showMoreReplies(context);
        },
        child: Row(
          children: [
            const Text(
              '展开',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(237, 176, 35, 1),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${comment.hiddenRepliesCount} 条回复',
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(237, 176, 35, 1),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: Color.fromRGBO(237, 176, 35, 1),
            ),
          ],
        ),
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
                  onPressed: () {
                    // 发送回复逻辑
                    Navigator.pop(context);
                  },
                  child: const Text('发送'),
                ),
              ],
            ),
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
              const Text(
                '全部回复',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: comment.hiddenRepliesCount + comment.replies.length,
                  itemBuilder: (context, index) {
                    if (index < comment.replies.length) {
                      return CommentItem(comment: comment.replies[index], isReply: true);
                    } else {
                      // 这里可以加载更多隐藏的回复
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