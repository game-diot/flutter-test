import 'package:flutter/material.dart';

class LeftExtraPanel extends StatelessWidget {
  final double? currentValue; // 当前值
  const LeftExtraPanel({super.key, this.currentValue});

  @override
  Widget build(BuildContext context) {
    String displayValue = (currentValue == null || currentValue == 0) ? '---' : currentValue!.toStringAsFixed(0);

    return Column(
      children: [
        // 第一组
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("max", style: TextStyle(fontSize: 12)),
                    Text("margin", style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                 
                    const Text("990109522", style: TextStyle(fontSize: 12)),
                       Text(displayValue, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.show_chart, color: Colors.white),
                label: const Text(
                  "上升趋势",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(45, 184, 128, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 第二组
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("min", style: TextStyle(fontSize: 12)),
                    Text("margin", style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  
                    const Text("990109522", style: TextStyle(fontSize: 12)),
                      Text(displayValue, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.show_chart, color: Colors.white),
                label: const Text(
                  "下降趋势",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(238, 68, 86, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
