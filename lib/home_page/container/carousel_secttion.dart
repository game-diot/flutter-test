import 'package:flutter/material.dart';

class CarouselSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130, // 固定高度
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: PageView(
          children: [
            _buildCarouselImage('assets/images/行情页指数图.png'),
            _buildCarouselImage('assets/images/行情页指数图.png'),
            _buildCarouselImage('assets/images/行情页指数图.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        color: const Color.fromARGB(255, 255, 255, 255), // 可选：背景色辅助观察
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: 1.7, // 例如 2:1 的宽高比（宽:高 = 300:150）
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover, // 保留比例且不裁剪，居中展示
          ),
        ),
      ),
    );
  }
}
