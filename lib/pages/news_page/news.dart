import 'package:flutter/material.dart';
import 'header/header.dart';
import 'container/news_carousel.dart';
import 'container/article.dart';
import 'components/article_model.dart';
import '../../network/Get/models/news_page/news.dart';
import '../../network/Get/services/news_page/news.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 0; // 当前选中的 tab
  late Future<List<News>> _futureMessages;

  @override
  void initState() {
    super.initState();
    _futureMessages = NewsServices().fetchNewsMessages().then(
      (resp) => resp.list,
    ); // 获取 list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 顶部 NewsHeader
          NewsHeader(
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),

          SizedBox(height: 32),

          // 内容
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  /// 根据 tab 切换展示内容
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0: // 热搜
        return FutureBuilder<List<News>>(
          future: _futureMessages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('加载失败: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmpty("暂无数据");
            }

            final messages = snapshot.data!;

            // 新闻轮播数据取前 5 条
            final carouselItems = messages.take(5).map((msg) {
              return NewsCarouselItem(
                title: msg.messageTitle,
                hotValue: msg.viewVolume, // 可以用 viewVolume 或 likeCount
              );
            }).toList();

            return Column(
              children: [
                NewsCarousel(items: carouselItems),
                SizedBox(height: 12),
                // 文章列表
                Expanded(
                  child: SingleChildScrollView(
                    child: ArticleList(
                      articles: messages.map((msg) {
                        return ArticleOverviewItem(
                          title: msg.messageTitle,
                          publishDate: msg.createTime,
                          imageUrl: msg.imgUrl ?? msg.authorityAvatar,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
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
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.grey)),
    );
  }
}
