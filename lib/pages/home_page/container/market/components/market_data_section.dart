import 'package:flutter/material.dart';
import '../../../../../network/Get/models/home_page/home_data_section.dart';
import '../../data_section/data_section.dart';

class MarketDataSection extends StatelessWidget {
  final List<SymbolItem> coinList;
  final bool isLoading;

  const MarketDataSection({super.key, required this.coinList, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      child: isLoading
          ? SizedBox(
              height: 400,
              child: Center(
                child: CircularProgressIndicator(color: theme.colorScheme.primary),
              ),
            )
          : DataSection(coinList: coinList),
    );
  }
}
