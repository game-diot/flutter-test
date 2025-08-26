import 'package:flutter/material.dart';

// 数据模型
class NewsCarouselItem {
  final String title;
  final int hotValue;

  NewsCarouselItem({required this.title, required this.hotValue});
}

// 轮播组件
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
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 16), // 左边距，让第一个项目贴边
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final bgImage = _backgroundImages[index % _backgroundImages.length];

          return Padding(
            padding: const EdgeInsets.only(right: 8), // 右边距
            child: SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(bgImage, fit: BoxFit.cover),
                    Container(color: Colors.black.withOpacity(0.3)),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center, // 水平居中
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
                        '热度值 ${item.hotValue}',
                        style: TextStyle(
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
