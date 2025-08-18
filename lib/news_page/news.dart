import 'package:flutter/material.dart';
import 'header/header.dart';
import 'container/news_carousel.dart'; // ← 注意导入路径，和文件实际位置一致
import 'container/article.dart';
import 'container/article_model.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // 示例文章列表
  final List<ArticleOverviewItem> articles = [
    ArticleOverviewItem(
      title: 'Flutter 3.0 发布：性能提升与新特性',
      publishDate: DateTime(2025, 8, 18),
      imageUrl: 'assets/images/news_red.png',
    ),
    ArticleOverviewItem(
      title: '人工智能在大数据分析中的应用',
      publishDate: DateTime(2025, 8, 17),
      imageUrl: 'assets/images/news_blue.png',
    ),
     ArticleOverviewItem(
      title: '人工智能在大数据分析中的应用',
      publishDate: DateTime(2025, 8, 17),
      imageUrl: 'assets/images/news_blue.png',
    ),
     ArticleOverviewItem(
      title: '人工智能在大数据分析中的应用',
      publishDate: DateTime(2025, 8, 17),
      imageUrl: 'assets/images/news_blue.png',
    ),
     ArticleOverviewItem(
      title: '人工智能在大数据分析中的应用',
      publishDate: DateTime(2025, 8, 17),
      imageUrl: 'assets/images/news_blue.png',
    ),
     ArticleOverviewItem(
      title: '人工智能在大数据分析中的应用',
      publishDate: DateTime(2025, 8, 17),
      imageUrl: 'assets/images/news_blue.png',
    ),
     ArticleOverviewItem(
      title: '人工智能在大数据分析中的应用',
      publishDate: DateTime(2025, 8, 17),
      imageUrl: 'assets/images/news_blue.png',
    ),
  ];

  Widget buildContentBlock(BuildContext context, String title) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.blue[800]),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NewsHeader(),
          SizedBox(height: 10),

          // ✅ 新闻轮播
          NewsCarousel(
            items: [
              NewsCarouselItem(title: "阿宋好嗲速度护额我电话iu啊是对我好对我好", hotValue: 173),
              NewsCarouselItem(title: "阿佛塑科技打开手机打死宽度", hotValue: 150),
              NewsCarouselItem(title: "在下面，刹那间啊睡觉哦i为i啊思考电话", hotValue: 98),
            ],
          ),

          SizedBox(height: 10),

          // 下方滚动区域
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...articles.map((a) => ArticleOverview(item: a)).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
