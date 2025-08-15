import 'package:flutter/material.dart';

class CarouselSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // 设置轮播图的高度
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: PageView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Image.asset('lib/home_page/container/首页海报3.png', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Image.asset('lib/home_page/container/首页海报3.png', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Image.asset('lib/home_page/container/首页海报3.png', fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
