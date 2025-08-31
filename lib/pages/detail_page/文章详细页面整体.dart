import 'package:flutter/material.dart';

// =================== DetailPage ===================
class DetailPage extends StatelessWidget {
  final String title;
  final String avatarUrl;
  final String nickname;
  final String time;
  final String content;
  final int starCount;
  final int likeCount;
  final int commentCount;

  const DetailPage({
    super.key,
    required this.title,
    required this.avatarUrl,
    required this.nickname,
    required this.time,
    required this.content,
    this.starCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      bottomNavigationBar: DetailBottomBar(
        starCount: starCount,
        likeCount: likeCount,
        commentCount: commentCount,
        onCommentTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              color: isDark ? Colors.grey[850] : Colors.white,
              child: Center(
                child: Text(
                  '评论输入框...',
                  style: TextStyle(
                      color: isDark ? const Color(0xFFDFE5EC) : Colors.black),
                ),
              ),
            ),
          );
        },
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CommonHeader(title: "文章详情"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            DetailTitle(title: title),
            DetailUserInfo(
              avatarUrl: avatarUrl,
              nickname: nickname,
              time: time,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DetailContent(content: content),
                    const DetailDivider(),
                    const CommentSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================== CommonHeader ===================
class CommonHeader extends StatelessWidget {
  final String title;

  const CommonHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        color: isDark ? Colors.white : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: isDark ? const Color(0xFFDFE5EC) : Colors.black,
        ),
      ),
      centerTitle: true,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      elevation: 0,
      foregroundColor: isDark ? Colors.white : Colors.black,
    );
  }
}

// =================== DetailTitle ===================
class DetailTitle extends StatelessWidget {
  final String title;

  const DetailTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// =================== DetailUserInfo ===================
class DetailUserInfo extends StatelessWidget {
  final String avatarUrl;
  final String nickname;
  final String time;

  const DetailUserInfo({
    super.key,
    required this.avatarUrl,
    required this.nickname,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
            radius: 18,
          ),
          const SizedBox(width: 8),
          Text(nickname),
          const Spacer(),
          Text(
            time,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}

// =================== DetailContent ===================
class DetailContent extends StatelessWidget {
  final String content;

  const DetailContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

// =================== DetailDivider ===================
class DetailDivider extends StatelessWidget {
  const DetailDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 8,
      color: Color.fromRGBO(241, 245, 249, 1),
      height: 20,
    );
  }
}

// =================== DetailBottomBar ===================
class DetailBottomBar extends StatelessWidget {
  final VoidCallback onCommentTap;
  final int starCount;
  final int likeCount;
  final int commentCount;

  const DetailBottomBar({
    super.key,
    required this.onCommentTap,
    this.starCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  Widget _buildIconWithText(IconData icon, int count, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 2),
        Text('$count', style: TextStyle(fontSize: 10, color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final inputBgColor = isDark ? Colors.grey[800] : const Color(0xFFF0F0F0);
    final textColor = isDark ? Colors.white70 : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isDark ? Colors.grey[700]! : const Color(0xFFEEEEEE))),
        color: bgColor,
      ),
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onCommentTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: inputBgColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text('我来评论', style: TextStyle(color: textColor)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildIconWithText(Icons.star_border, starCount, textColor),
          const SizedBox(width: 16),
          _buildIconWithText(Icons.thumb_up_off_alt, likeCount, textColor),
          const SizedBox(width: 16),
          _buildIconWithText(Icons.chat_bubble_outline, commentCount, textColor),
        ],
      ),
    );
  }
}

// =================== CommentModel ===================
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

// =================== CommentSection ===================
class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
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
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('全部回复', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        ...comments.map((comment) => CommentItem(comment: comment)),
      ],
    );
  }
}

// =================== CommentItem ===================
class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final bool isReply;

  const CommentItem({super.key, required this.comment, this.isReply = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCommentContent(context),
        if (comment.replies.isNotEmpty)
          ...comment.replies.map((reply) => Padding(
                padding: const EdgeInsets.only(left: 50),
                child: CommentItem(comment: reply, isReply: true),
              )),
        if (comment.hasMoreReplies) ViewMoreReplies(comment: comment),
      ],
    );
  }

  Widget _buildCommentContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: isReply ? 8 : 12, bottom: isReply ? 8 : 12),
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
                Text(comment.username, style: const TextStyle(color: Color.fromRGBO(134, 144, 156, 1), fontSize: 13)),
                const SizedBox(height: 4),
                Text(comment.content, style: TextStyle(fontSize: isReply ? 13 : 14)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(comment.time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _showReplyDialog(context),
                      child: const Text('回复', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                child: Icon(Icons.thumb_up_alt_outlined, size: isReply ? 18 : 20, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text('${comment.likeCount}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
            const Text('回复评论', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: '回复 ${comment.username}...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
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

// =================== ViewMoreReplies ===================
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
