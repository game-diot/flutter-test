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
