import 'package:flutter/material.dart';
import '../../home_page/container/data_section/models/combined_coin_data.dart';

class HeaderInfo extends StatelessWidget {
  final CombinedCoinData coin;
  final bool switchValue;
  final ValueChanged<bool> onSwitchChanged;

  const HeaderInfo({
    Key? key,
    required this.coin,
    required this.switchValue,
    required this.onSwitchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    coin.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '永续',
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
              Text(
                "${coin.priceChangePercent?.toStringAsFixed(2) ?? '--'}%",
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text("123/456", style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text("789/012", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
