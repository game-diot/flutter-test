// components/setting_item_detail_page/change_color_detail_page/trend_color_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/color/color.dart';

class TrendColorDetailPage extends StatelessWidget {
  const TrendColorDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ChangeColorProvider>(context);
    final currentMode = colorProvider.mode;
    final selectedIndex = currentMode == ChangeColorMode.greenUpRedDown ? 0 : 1;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('涨跌色设置'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        foregroundColor:
            theme.appBarTheme.foregroundColor ??
            theme.textTheme.titleLarge?.color,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '调整市场行情显示的涨跌颜色，直观区分涨跌情况',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildDetailBlock(context, 0, selectedIndex == 0),
            const SizedBox(height: 16),
            _buildDetailBlock(context, 1, selectedIndex == 1),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailBlock(BuildContext context, int index, bool isSelected) {
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
                      (block) => _buildMiniBlock(
                        block['color'] as Color,
                        block['text'] as String,
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

  Widget _buildMiniBlock(Color color, String text) {
    return Container(
      width: 80,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
