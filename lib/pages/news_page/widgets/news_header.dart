import 'package:flutter/material.dart';
import '../../../localization/i18n/lang.dart';

class NewsHeader extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;

  const NewsHeader({Key? key, this.onTabSelected}) : super(key: key);

  @override
  State<NewsHeader> createState() => _NewsHeaderState();
}

class _NewsHeaderState extends State<NewsHeader> {
  int _selectedIndex = 0;
  final List<String> _labels = [
    Lang.t('hot_rank'),
    Lang.t('square'),
    Lang.t('original'),
    Lang.t('nft'),
    Lang.t('science'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFEDB023);
    final textColor = isDark ? const Color(0xFFEFEFEF) : Colors.black;
    final searchBgColor = isDark ? const Color(0xFF424242) : Colors.white;
    final searchTextColor = isDark ? const Color(0xFF9D9D9D) : Colors.black87;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: searchBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: Colors.grey, size: 28),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: searchTextColor),
                    decoration: const InputDecoration(
                      hintText: '搜索新闻',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_labels.length, (index) {
                final isSelected = _selectedIndex == index;
                return SizedBox(
                  width: 350 / _labels.length,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      widget.onTabSelected?.call(index);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _labels[index],
                          style: TextStyle(
                            color: textColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 15,
                          height: 2,
                          color: isSelected ? textColor : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
