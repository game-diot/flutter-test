import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../../../../../localization/i18n/lang.dart';

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
          padding: const EdgeInsets.only(left: 2), // 左侧整体间距 6px
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(4, (index) {
              final labels = [
                Lang.t('main_coins'),
                Lang.t('hot_list'),
                Lang.t('gainers_list'),
                Lang.t('exchanges'),
              ];

              final isSelected = selectedIndex == index;
              final labelColor = isSelected
                  ? textColor
                  : Color.fromRGBO(134, 144, 156, 1);

              return Padding(
                padding: EdgeInsets.only(
                  right: index == 3 ? 0 : 16, // 每个文字右侧间距 16px，最后一个不加
                ),
                child: GestureDetector(
                  onTap: () => onTabChanged(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          left: 6,
                          right: 6,
                        ), // 下边距 4px
                        child: Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: labelColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          height: 4,
                          width: 15,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(237, 176, 35, 1),
                            borderRadius: BorderRadius.circular(2),
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
