class ArticleOverviewItem {
  final String title;       // 文章标题或简介
  final DateTime publishDate; // 发布时间
  final String imageUrl;    // 封面图片路径

  ArticleOverviewItem({
    required this.title,
    required this.publishDate,
    required this.imageUrl,
  });
}
