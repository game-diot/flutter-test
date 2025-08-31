import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../../../../../localization/i18n/lang.dart';

/// 顶部切换栏组件
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

    final labels = [
      Lang.t('main_coins'),
      Lang.t('hot_list'),
      Lang.t('gainers_list'),
      Lang.t('exchanges'),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Row(
            children: List.generate(labels.length, (index) {
              final isSelected = selectedIndex == index;
              final labelColor = isSelected
                  ? textColor
                  : const Color.fromRGBO(134, 144, 156, 1);

              return Padding(
                padding: EdgeInsets.only(
                  right: index == labels.length - 1 ? 0 : 16,
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
                        ),
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
