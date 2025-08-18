// lib/components/forum_header.dart
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

  // 搜索框 + 5个文字，点击文字显示底部边框
  Widget buildTextWithBorder(int index, String title) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        _onTabSelected(index); // 更新选中
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 40,
            height: 2,
            color: isSelected ? const Color.fromRGBO(237, 176, 35, 1) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 搜索框
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '搜索论坛',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
        ),
        
        // 文字部分，点击后添加下边框
        Container(
          color: Colors.white, // 背景色为白色
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTextWithBorder(0, '热榜'),
              buildTextWithBorder(1, '区块链'),
              buildTextWithBorder(2, '心得'),
              buildTextWithBorder(3, '吐槽大会'),
              buildTextWithBorder(4, 'Tab'),
            ],
          ),
        ),
      ],
    );
  }
}
