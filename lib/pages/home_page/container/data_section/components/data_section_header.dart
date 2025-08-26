
// ==========================================
// lib/home_page/data_section/widgets/data_section_header.dart
// ==========================================

import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

/// 数据区域顶部切换栏
class DataSectionHeader extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const DataSectionHeader({
    Key? key,
    required this.selectedIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    final textColor = isLight ? Colors.black : Colors.white;
    final subTextColor = isLight ? Colors.grey[700] : Colors.grey[400];
    final dividerColor = isLight ? Colors.grey.withOpacity(0.3) : Colors.grey[700];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(4, (index) {
            final labels = ['主流币', '热门榜', '涨幅榜', '交易所'];
            final isSelected = selectedIndex == index;
            final labelColor = isSelected ? textColor : subTextColor;

            return SizedBox(
              width: 80,
              child: GestureDetector(
                onTap: () => onTabChanged(index),
                child: Column(
                  children: [
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: labelColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        height: 2,
                        width: 40,
                        color: const Color.fromRGBO(237, 176, 35, 1),
                        margin: const EdgeInsets.only(top: 4),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: dividerColor),
      ],
    );
  }
}
