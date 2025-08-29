import 'package:flutter/material.dart';
import '../../home_page/container/data_section/models/combined_coin_data.dart';

class RightPanel extends StatelessWidget {
  final CombinedCoinData coin;

  const RightPanel({Key? key, required this.coin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

          // 数据列表
          Expanded(
            child: ListView.builder(
              itemCount: 10, // 数据长度
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${(coin.currentPrice ?? 1000) + index}"),
                    Text("${(index + 1) * 5}"),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
