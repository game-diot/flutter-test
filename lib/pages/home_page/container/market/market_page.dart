import 'package:flutter/material.dart';
import '../../../../network/Get/models/home_page/home_data_section.dart';
import 'components/market_header.dart';
import 'components/market_banner.dart';
import 'components/market_carousel.dart';
import 'components/market_row_section.dart';
import 'components/market_data_section.dart';

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
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          const MarketHeader(),
          const MarketBanner(),
          Align(
            alignment: Alignment.centerLeft,
            child: MarketCarousel(coinList: coinList, isLoading: isLoading),
          ),

          const SizedBox(height: 10),
          const MarketRowSection(),
          const SizedBox(height: 13),
          MarketDataSection(coinList: coinList, isLoading: isLoading),
        ],
      ),
    );
  }
}
