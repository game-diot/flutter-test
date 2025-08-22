import 'package:flutter/material.dart';

class ForumHeader extends StatefulWidget {
  final ValueChanged<int>? onTabSelected; // 新增回调

  const ForumHeader({super.key, this.onTabSelected});

  @override
  _ForumHeaderState createState() => _ForumHeaderState();
}

class _ForumHeaderState extends State<ForumHeader> {
  int _selectedIndex = 0; // 默认选中第一个文字

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabSelected?.call(index); // 把 index 回传给 ForumPage
  }

  Widget buildTextWithBorder(int index, String title, bool isDark) {
    bool isSelected = _selectedIndex == index;
    Color textColor = isDark
        ? Colors.white.withOpacity(isSelected ? 1.0 : 0.7)
        : (isSelected ? Colors.black : Colors.grey);
    Color borderColor = const Color.fromRGBO(237, 176, 35, 1);

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 40,
            height: 2,
            color: isSelected ? borderColor : Colors.transparent,
            margin: EdgeInsets.only(top: 4),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final searchBg = isDark ? const Color.fromRGBO(66, 66, 66, 1) : Colors.white;
    final searchIconColor = Colors.grey;

    return Column(
      children: [
        // 搜索框
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                hintText: '搜索论坛',
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
          color: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildTextWithBorder(0, '热榜', isDark),
              buildTextWithBorder(1, '区块链', isDark),
              buildTextWithBorder(2, '心得', isDark),
              buildTextWithBorder(3, '吐槽大会', isDark),
              buildTextWithBorder(4, 'Tab', isDark),
            ],
          ),
        ),
      ],
    );
  }
}
