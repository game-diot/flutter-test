import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/color/color.dart';

class PriceChange extends StatelessWidget {
  final double? priceChangePercent;
  final bool hasRealTimeData;
  final Color textColor;

  const PriceChange({
    Key? key,
    required this.priceChangePercent,
    required this.hasRealTimeData,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!hasRealTimeData || priceChangePercent == null) {
      return Text(
        '--',
        textAlign: TextAlign.right,
        style: TextStyle(color: textColor.withOpacity(0.5)),
      );
    }

    return Consumer<ChangeColorProvider>(
      builder: (context, colorProvider, _) {
        final mode = colorProvider.mode;
        final isUp = priceChangePercent! >= 0;
        final valueColor = mode == ChangeColorMode.greenUpRedDown
            ? (isUp ? Colors.green : Colors.red)
            : (isUp ? Colors.red : Colors.green);

        return Text(
          '${priceChangePercent!.toStringAsFixed(2)}%',
          textAlign: TextAlign.right,
          style: TextStyle(color: valueColor),
        );
      },
    );
  }
}
