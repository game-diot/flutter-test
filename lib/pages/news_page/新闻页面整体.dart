// news_page.dart
import 'package:flutter/material.dart';
import '../../network/Get/models/news_page/news.dart';
import '../../network/Get/services/news_page/news.dart';
import '../../localization/i18n/lang.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 0; // 当前选中的 tab
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
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          const SizedBox(height: 32),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0: // 热搜
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
                    child: Column(
                      children: articleItems
                          .map((item) => ArticleOverview(item: item))
                          .toList(),
                    ),
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

/// ===================== 内部 Widget =====================

class NewsHeader extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;

  const NewsHeader({Key? key, this.onTabSelected}) : super(key: key);

  @override
  State<NewsHeader> createState() => _NewsHeaderState();
}

class _NewsHeaderState extends State<NewsHeader> {
  int _selectedIndex = 0;
  final List<String> _labels = [
    Lang.t('hot_rank'),
    Lang.t('square'),
    Lang.t('original'),
    Lang.t('nft'),
    Lang.t('science'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFEDB023);
    final textColor = isDark ? const Color(0xFFEFEFEF) : Colors.black;
    final searchBgColor = isDark ? const Color(0xFF424242) : Colors.white;
    final searchTextColor = isDark ? const Color(0xFF9D9D9D) : Colors.black87;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索框
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: searchBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(
                    Icons.search_rounded,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: searchTextColor),
                    decoration: const InputDecoration(
                      hintText: '搜索新闻',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tab 按钮
          SizedBox(
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_labels.length, (index) {
                final isSelected = _selectedIndex == index;
                return SizedBox(
                  width: 350 / _labels.length,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      widget.onTabSelected?.call(index);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _labels[index],
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 15,
                          height: 2,
                          color: isSelected ? textColor : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================== 新闻轮播 =====================

class NewsCarouselItem {
  final String title;
  final int hotValue;

  NewsCarouselItem({required this.title, required this.hotValue});
}

class NewsCarousel extends StatelessWidget {
  final List<NewsCarouselItem> items;

  static const List<String> _backgroundImages = [
    'assets/images/news_red.png',
    'assets/images/news_blue.png',
  ];

  const NewsCarousel({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final bgImage = _backgroundImages[index % _backgroundImages.length];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 170,
              height: 170,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(bgImage, fit: BoxFit.cover),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 4,
                      bottom: 4,
                      child: Text(
                        '${Lang.t('hot_value')} ${item.hotValue}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ===================== 文章展示 =====================

class ArticleOverviewItem {
  final String title;
  final DateTime publishDate;
  final String imageUrl;

  ArticleOverviewItem({
    required this.title,
    required this.publishDate,
    required this.imageUrl,
  });
}

class ArticleOverview extends StatelessWidget {
  final ArticleOverviewItem item;

  const ArticleOverview({Key? key, required this.item}) : super(key: key);

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[850] : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black;
    final dateColor = isDark ? Colors.white70 : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _formatDate(item.publishDate),
                  style: TextStyle(fontSize: 12, color: dateColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.imageUrl.startsWith('http')
                ? Image.network(
                    item.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    item.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    );
  }
}
