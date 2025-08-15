// lib/components/forum_header.dart
import 'package:flutter/material.dart';

class ForumHeader extends StatefulWidget {
  @override
  _ForumHeaderState createState() => _ForumHeaderState();
}

class _ForumHeaderState extends State<ForumHeader> {
  int _selectedIndex = -1; // 初始没有选中任何文字

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index; // 更新选中的文字
    });
  }

  // 搜索框 + 5个文字，点击文字显示底部边框
  Widget buildTextWithBorder(int index, String title) {
    return GestureDetector(
      onTap: () {
        _onTabSelected(index); // 更新选中
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 40,
            height: 2,
            color: _selectedIndex == index ? Colors.white : Colors.transparent,
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
          color: Colors.blue, // 背景色为蓝色
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTextWithBorder(0, '板块1'),
              buildTextWithBorder(1, '板块2'),
              buildTextWithBorder(2, '板块3'),
              buildTextWithBorder(3, '板块4'),
              buildTextWithBorder(4, '板块5'),
            ],
          ),
        ),
      ],
    );
  }
}
