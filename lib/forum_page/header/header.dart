import 'package:flutter/material.dart';

class ForumHeader extends StatefulWidget {
  @override
  _ForumHeaderState createState() => _ForumHeaderState();
}

class _ForumHeaderState extends State<ForumHeader> {
  int _selectedIndex = 0; // 默认选中第一个文字

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index; // 更新选中
    });
  }

  // 搜索框 + 文字点击显示底部边框
  Widget buildTextWithBorder(int index, String title, bool isDark) {
    bool isSelected = _selectedIndex == index;
    Color textColor = isDark
        ? Colors.white.withOpacity(isSelected ? 1.0 : 0.7)
        : (isSelected ? Colors.black : Colors.grey);
    Color borderColor = isDark
        ? Colors.transparent
        : Color.fromRGBO(237, 176, 35, 1);

    return GestureDetector(
      onTap: () {
        _onTabSelected(index);
      },
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
    final searchBg = isDark ? Color.fromRGBO(223, 229, 236, 1) : Colors.white;
    final searchIconColor = Colors.grey;

    return Column(
      children: [
        // 搜索框
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromRGBO(223, 229, 236, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: searchIconColor),
                hintText: '搜索论坛',
                hintStyle: TextStyle(color: searchIconColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
            ),
          ),
        ),

        // 文字部分
        Container(
          color: bgColor,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            spacing: 30,
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
