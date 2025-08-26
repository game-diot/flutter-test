import 'package:flutter/material.dart';
import 'header/header.dart';
import 'container/news_carousel.dart';
import 'components/article_widget.dart';
import 'components/article_model.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 0; // 当前选中的 tab

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 顶部 NewsHeader，传回点击的 index
          NewsHeader(
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),

          SizedBox(height: 10),

          // 根据不同 tab 展示不同内容
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  /// 根据 tab 切换展示内容
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0: // 热搜，显示完整页面
        return Column(
          children: [
            // 新闻轮播
            NewsCarousel(
              items: [
                NewsCarouselItem(title: "阿宋好嗲速度护额我电话iu啊是对我好对我好", hotValue: 173),
                NewsCarouselItem(title: "阿佛塑科技打开手机打死宽度", hotValue: 150),
                NewsCarouselItem(title: "在下面，刹那间啊睡觉哦i为i啊思考电话", hotValue: 98),
              ],
            ),
            SizedBox(height: 10),

            // 文章列表（用 Expanded 包裹，撑满剩余空间）
            Expanded(
              child: SingleChildScrollView(
                child: ArticleList(articles: articles),
              ),
            ),
          ],
        );

      case 1:
        return _buildEmpty("暂无广场数据，请稍后查看");
      case 2:
        return _buildEmpty("暂无原创数据，请稍后查看");
      case 3:
        return _buildEmpty("暂无 NFT 数据，请稍后查看");
      case 4:
        return _buildEmpty("暂无科普数据，请稍后查看");
      default:
        return _buildEmpty("暂无数据");
    }
  }

  /// 占位页
  Widget _buildEmpty(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
