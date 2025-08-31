import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/color/color.dart';
import 'widgets/detail_block.dart';

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
            DetailBlock(index: 0, isSelected: selectedIndex == 0),
            const SizedBox(height: 16),
            DetailBlock(index: 1, isSelected: selectedIndex == 1),
          ],
        ),
      ),
    );
  }
}
