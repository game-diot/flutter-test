import 'package:flutter/material.dart';
import 'widgets/news_header.dart';
import 'widgets/news_carousel.dart';
import 'widgets/article_list.dart';
import 'models/article_model.dart';
import '../../network/Get/models/news_page/news.dart';
import '../../network/Get/services/news_page/news.dart';
import '../../localization/i18n/lang.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 0;
  late Future<List<News>> _futureMessages;

  @override
  void initState() {
    super.initState();
    _futureMessages = NewsServices().fetchNewsMessages().then(
      (resp) => resp.list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NewsHeader(
            onTabSelected: (index) => setState(() => _selectedIndex = index),
          ),
          const SizedBox(height: 32),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return FutureBuilder<List<News>>(
          future: _futureMessages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${Lang.t('load_failed')}: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmpty(Lang.t('no_data'));
            }

            final messages = snapshot.data!;
            final carouselItems = messages.take(5).map((msg) {
              return NewsCarouselItem(
                title: msg.messageTitle,
                hotValue: msg.viewVolume,
              );
            }).toList();

            final articleItems = messages.map((msg) {
              return ArticleOverviewItem(
                title: msg.messageTitle,
                publishDate: msg.createTime,
                imageUrl: msg.imgUrl ?? msg.authorityAvatar,
              );
            }).toList();

            return Column(
              children: [
                NewsCarousel(items: carouselItems),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: ArticleList(articles: articleItems),
                  ),
                ),
              ],
            );
          },
        );

      case 1:
        return _buildEmpty(Lang.t('no_square_data'));
      case 2:
        return _buildEmpty(Lang.t('no_original_data'));
      case 3:
        return _buildEmpty(Lang.t('no_nft_data'));
      case 4:
        return _buildEmpty(Lang.t('no_science_data'));
      default:
        return _buildEmpty(Lang.t('no_data'));
    }
  }

  Widget _buildEmpty(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
