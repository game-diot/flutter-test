import 'package:flutter/material.dart';
import '../models/article_model.dart';
import 'article_overview.dart';

class ArticleList extends StatelessWidget {
  final List<ArticleOverviewItem> articles;
  const ArticleList({Key? key, required this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: articles
          .map((article) => ArticleOverview(item: article))
          .toList(),
    );
  }
}
