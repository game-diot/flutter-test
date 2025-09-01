import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../providers/color/color.dart';
import 'mini_block.dart';

class DetailBlock extends StatelessWidget {
  final int index;
  final bool isSelected;

  const DetailBlock({super.key, required this.index, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ChangeColorProvider>(context);
    final isGreenUp = index == 0;

    final leftSvg = isGreenUp
        ? 'assets/svgs/green_red.svg'
        : 'assets/svgs/red_green.svg';
    final leftText = isGreenUp ? '绿涨红跌' : '红涨绿跌';

    final miniBlocks = isGreenUp
        ? [
            {'color': Colors.grey.shade300, 'text': ''},
            {'color': Colors.green, 'text': '+3.25%'},
            {'color': Colors.grey.shade300, 'text': ''},
            {'color': Colors.red, 'text': '-2.15%'},
          ]
        : [
            {'color': Colors.grey.shade300, 'text': ''},
            {'color': Colors.red, 'text': '-3.25%'},
            {'color': Colors.grey.shade300, 'text': ''},
            {'color': Colors.green, 'text': '+2.15%'},
          ];

    return GestureDetector(
      onTap: () {
        colorProvider.setMode(
          isGreenUp
              ? ChangeColorMode.greenUpRedDown
              : ChangeColorMode.redUpGreenDown,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(leftSvg, width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(
                        leftText,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('BTC-USDT', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: miniBlocks
                    .map(
                      (block) => MiniBlock(
                        color: block['color'] as Color,
                        text: block['text'] as String,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
