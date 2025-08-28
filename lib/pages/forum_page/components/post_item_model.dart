class ForumPostItem {
  final String title;
  final String author;
  final String content;
  final String imageUrl;
  final DateTime createTime;
  final int likes;
  final int comments;
  final int? rank;

  ForumPostItem({
    required this.title,
    required this.author,
    required this.content,
    required this.imageUrl,
    required this.createTime,
    this.likes = 0,
    this.comments = 0,
    this.rank,
  });
}
