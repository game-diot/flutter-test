import 'package:flutter/material.dart';

class MarketBanner extends StatelessWidget {
  const MarketBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: 150,
          child: Image.asset(
            'assets/images/行情页广告图.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              child: Center(
                child: Text(
                  '图片加载失败',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
