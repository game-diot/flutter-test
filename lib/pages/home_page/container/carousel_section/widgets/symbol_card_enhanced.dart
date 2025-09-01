import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/combined_chart_data.dart';
import 'line_chart_enhanced.dart';
import '../../../../../../providers/color/color.dart';
import '../../../../../localization/i18n/lang.dart';

class SymbolCardEnhanced extends StatelessWidget {
  final CombinedChartData item;
  final bool isLight;

  const SymbolCardEnhanced({
    Key? key,
    required this.item,
    required this.isLight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayPrice = item.hasRealTimeData && item.currentPrice != null
        ? item.currentPrice!
        : (item.miniKlinePriceList.isNotEmpty
              ? item.miniKlinePriceList.first
              : 0.0);

    final displayChange =
        item.hasRealTimeData && item.priceChangePercent != null
        ? item.priceChangePercent!
        : (item.miniKlinePriceList.length > 1
              ? item.miniKlinePriceList[1]
              : 0.0);

    final lineData = item.chartData.take(20).toList();

    final colorProvider = context.watch<ChangeColorProvider>();
    final changeColor = colorProvider.mode == ChangeColorMode.redUpGreenDown
        ? (displayChange >= 0 ? Colors.red : Colors.green)
        : (displayChange >= 0 ? Colors.green : Colors.red);

    return Container(
      decoration: BoxDecoration(
        color: isLight ? Colors.white : Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isLight
                ? Colors.black.withOpacity(0.05)
                : Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                item.icon1,
                width: 20,
                height: 20,
                errorBuilder: (_, __, ___) => Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.currency_bitcoin,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLight ? Colors.black : Colors.white,
                  ),
                ),
              ),
              if (item.hasRealTimeData)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '${Lang.t('price')}: ¥${displayPrice.toStringAsFixed(2)}',
            style: TextStyle(color: isLight ? Colors.black : Colors.white),
          ),
          Text(
            '${Lang.t('price_change_percent')}: ${displayChange.toStringAsFixed(2)}%',
            style: TextStyle(color: changeColor),
          ),
          SizedBox(height: 8),
          Expanded(
            child: lineData.isNotEmpty
                ? CustomPaint(
                    painter: LineChartEnhancedPainter(
                      lineData,
                      isLight,
                      changeColor,
                    ),
                    size: Size(double.infinity, 60),
                  )
                : Center(
                    child: Text(
                      Lang.t('no_chart_data'),
                      style: TextStyle(
                        color: isLight ? Colors.black54 : Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
