
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
  
    final dividerColor = isLight
        ? Colors.grey.withOpacity(0.3)
        : Colors.grey[700];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(4, (index) {
              final labels = ['主流币', '热门榜', '涨幅榜', '交易所'];
              final isSelected = selectedIndex == index;
              final labelColor = isSelected ? textColor : Color.fromRGBO(134, 144, 156,1);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ), // 左右16，文字间距32
                child: GestureDetector(
                  onTap: () => onTabChanged(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: labelColor,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          height: 4,
                          width: 20,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(237, 176, 35, 1),
                            borderRadius: BorderRadius.circular(2), // 圆角
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),

        Container(height: 1, color: dividerColor),
      ],
    );
  }
}
