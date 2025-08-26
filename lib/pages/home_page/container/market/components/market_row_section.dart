import 'package:flutter/material.dart';
import '../../row_section.dart';

class MarketRowSection extends StatelessWidget {
  const MarketRowSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      child:RowSection(),
    );
  }
}
