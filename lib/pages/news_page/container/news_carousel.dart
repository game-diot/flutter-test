import 'package:flutter/material.dart';
import '../../../localization/i18n/lang.dart'; // 假设你有语言包工具

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

  NewsCarousel({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 16),
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
                          style: TextStyle(
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
                        '${Lang.t('hot_value')} ${item.hotValue}', // 多语言显示
                        style: TextStyle(color: Colors.white70, fontSize: 10),
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
