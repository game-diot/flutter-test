import 'package:flutter/material.dart';
import '../../../localization/i18n/lang.dart';

class ForumHeader extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;

  const ForumHeader({super.key, this.onTabSelected});

  @override
  _ForumHeaderState createState() => _ForumHeaderState();
}

class _ForumHeaderState extends State<ForumHeader> {
  int _selectedIndex = 0;

  late List<String> _labels;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 获取当前语言下的 Tab 名称
    _labels = [
      Lang.t('hot_list'),
      Lang.t('blockchain'),
      Lang.t('experience'),
      Lang.t('complaint'),
      Lang.t('tab'),
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabSelected?.call(index);
  }

  Widget buildTextWithBorder(int index, bool isDark) {
    bool isSelected = _selectedIndex == index;
    Color textColor = isDark
        ? Colors.white.withOpacity(isSelected ? 1.0 : 0.7)
        : (isSelected
              ? Color.fromRGBO(41, 46, 56, 1)
              : Color.fromRGBO(46, 46, 46, 1));
    Color borderColor = const Color.fromARGB(255, 0, 0, 0);

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            _labels[index], // 使用多语言文字
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 20,
            height: 2,
            color: isSelected ? borderColor : Colors.transparent,
            margin: const EdgeInsets.only(top: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final searchBg = isDark
        ? const Color.fromRGBO(66, 66, 66, 1)
        : const Color.fromRGBO(242, 242, 242, 1);
    final searchIconColor = Colors.grey;

    return Column(
      children: [
        // 搜索框
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: searchBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: searchIconColor),
                hintText: Lang.t("search_forum"), // 多语言 hint
                hintStyle: TextStyle(color: searchIconColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
            ),
          ),
        ),

        // Tab 部分
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _labels.length,
              (i) => buildTextWithBorder(i, isDark),
            ),
          ),
        ),
      ],
    );
  }
}
