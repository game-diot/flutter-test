import 'package:flutter/material.dart';
import '../../../../../network/Get/models/home_page/home_data_section.dart';
import '../../carousel_section/carousel_section.dart';
import '../../../../../localization/i18n/lang.dart'; // ⬅️ 引入

class MarketCarousel extends StatelessWidget {
  final List<SymbolItem> coinList;
  final bool isLoading;

  const MarketCarousel({
    super.key,
    required this.coinList,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            Lang.t('global_index'), // ⬅️ 使用翻译
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
        Container(
          color: theme.cardColor,
          child: isLoading
              ? SizedBox(
                  height: 150,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                )
              : SymbolCarousel(coinList: coinList),
        ),
      ],
    );
  }
}
