// lib/container/article_list.dart
import 'package:flutter/material.dart';
import '../components/article.dart';
import '../components/article_model.dart';

class ArticleList extends StatelessWidget {
  final List<ArticleOverviewItem> articles;

  const ArticleList({Key? key, required this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: articles.map((article) => ArticleOverview(item: article)).toList(),
    );
  }
}
