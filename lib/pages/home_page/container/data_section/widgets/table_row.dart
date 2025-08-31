import 'package:flutter/material.dart';
import '../models/combined_coin_data.dart';
import 'coin_icon.dart';
import 'price_change.dart';

class CoinTableRow extends StatelessWidget {
  final CombinedCoinData item;
  final Color textColor;
  final Function(CombinedCoinData)? onRowTap;

  const CoinTableRow({
    Key? key,
    required this.item,
    required this.textColor,
    this.onRowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onRowTap?.call(item),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          children: [
            CoinIcon(iconUrl: item.icon1),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayName,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (item.symbol != item.baseSymbol)
                    Text(
                      item.symbol,
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: item.hasRealTimeData && item.currentPrice != null
                    ? Text(
                        '¥${item.currentPrice!.toStringAsFixed(2)}',
                        style: TextStyle(color: textColor),
                      )
                    : Text(
                        '--',
                        style: TextStyle(color: textColor.withOpacity(0.5)),
                      ),
              ),
            ),
            Expanded(
              flex: 1,
              child: PriceChange(
                priceChangePercent: item.priceChangePercent,
                hasRealTimeData: item.hasRealTimeData,
                textColor: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
