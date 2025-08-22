import 'package:flutter/material.dart';
import '../header/header.dart';
import '../container/carousel_section.dart';
import '../container/row_section.dart';
import '../container/data_section.dart';
import '../../network/Get/models/home_page/home_data_section.dart';

class MarketPage extends StatelessWidget {
  final List<SymbolItem> coinList;
  final bool isLoading;

  const MarketPage({
    super.key,
    required this.coinList,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          // Header 区域
          Container(
            color: isDark
                ? const Color.fromRGBO(18, 18, 18, 1)
                : const Color.fromRGBO(237, 176, 35, 1),
            child: const Column(children: [Header(), SizedBox(height: 10)]),
          ),
          const SizedBox(height: 10),

          // 广告图
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
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
          ),
          const SizedBox(height: 10),

          // 全球指数标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '全球指数',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Carousel 区块
          Container(
            color: theme.cardColor,
            child: isLoading
                ? SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(color: theme.colorScheme.primary),
                    ),
                  )
                : SymbolCarousel(coinList: coinList),
          ),
          const SizedBox(height: 10),

          // RowSection 区块
          Container(color: theme.cardColor, child: RowSection()),
          const SizedBox(height: 10),

          // DataSection 区块
          Container(
            color: theme.cardColor,
            child: isLoading
                ? SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(color: theme.colorScheme.primary),
                    ),
                  )
                : DataSection(coinList: coinList),
          ),
        ],
      ),
    );
  }
}
