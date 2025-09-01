import 'package:flutter/material.dart';
import '../models/model.dart';
import '../../../socket/home_page_data_section/exchange_depth_model.dart';

class RightPanel extends StatelessWidget {
  final CoinDetail coinDetail;           
  final ExchangeDepth? exchangeDepth;    

  const RightPanel({
    Key? key,
    required this.coinDetail,
    this.exchangeDepth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final asks = exchangeDepth?.asks.reversed.toList() ?? [];
    final bids = exchangeDepth?.bids.toList() ?? [];

    // 找到最大数量，用于背景长度比例
    double maxVolume = 0;
    if (asks.isNotEmpty || bids.isNotEmpty) {
      maxVolume = [
        if (asks.isNotEmpty) asks.map((e) => e.volume).reduce((a, b) => a > b ? a : b),
        if (bids.isNotEmpty) bids.map((e) => e.volume).reduce((a, b) => a > b ? a : b),
      ].reduce((a, b) => a > b ? a : b);
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // 表头
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("价格", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("数量", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 1),

          // 卖单列表（红色背景）
          ...asks.map((item) => _buildRow(item, maxVolume, isSell: true)),

          const Divider(height: 1),

          // 买单列表（绿色背景）
          ...bids.map((item) => _buildRow(item, maxVolume, isSell: false)),
        ],
      ),
    );
  }

  Widget _buildRow(OrderBookItem item, double maxVolume, {required bool isSell}) {
    final double widthFactor = maxVolume > 0 ? (item.volume / maxVolume) : 0.0;
    final bgColor = isSell ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: widthFactor,
            alignment: isSell ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              height: 28,
              color: bgColor,
            ),
          ),
          Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.price.toStringAsFixed(2), style: TextStyle(color: isSell ? Colors.red : Colors.green)),
                Text(item.volume.toStringAsFixed(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
