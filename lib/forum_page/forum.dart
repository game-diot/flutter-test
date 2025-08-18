// lib/pages/forum_page.dart
import 'package:flutter/material.dart';
import 'header/header.dart';
import '../components/navbar.dart';
import 'container/forumpostblock.dart';
class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int _selectedIndex = 3; // 默认是论坛 tab
  int _selectedFunctionIndex = 0; // 默认第一个功能被选中

  void _onTabSelected(int index) {
    if (index == _selectedIndex) return;

    Navigator.pushReplacementNamed(
      context,
      index == 0
          ? '/home'
          : index == 1
              ? '/news'
              : index == 2
                  ? '/add'
                  : index == 3
                      ? '/forum'
                      : '/settings',
    );
  }

  // 功能按钮组件
  Widget buildFunctionButton(int index, IconData icon, String label) {
  bool isSelected = _selectedFunctionIndex == index;

  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedFunctionIndex = index;
      });
    },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white, // 背景色，可自定义
        border: Border.all(
          color:Colors.grey, // 选中边框黑色，否则灰色
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8), // 圆角
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: Color.fromRGBO(237, 176, 35, 1)),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: 40,
            height: 2,
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 顶部 ForumHeader
            Container(
              color: Color.fromRGBO(237, 176, 35, 1),
              child: ForumHeader(),
            ),
            SizedBox(height: 10),

            // 横排功能 Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildFunctionButton(0, Icons.people, '今日热门'),
                  buildFunctionButton(1, Icons.lightbulb, '每周必看'),
                  buildFunctionButton(2, Icons.thumb_up, '热议话题'),
                  buildFunctionButton(3, Icons.chat, '辟谣专区'),
                ],
              ),
            ),
            SizedBox(height: 10),

            // 下方内容
           Expanded(
  child: SingleChildScrollView(
    child: Column(
      children: [
        ForumPostBlock(
          tagIcon: Icons.whatshot,
          title: '区块链最新动态',
          author: '张三',
          content: '今天区块链又有新的发展趋势，需要关注市场变化...',
          likes: 12,
          comments: 3,
          rank: 1,
        ),
        ForumPostBlock(
          tagIcon: Icons.whatshot,
          title: '区块链最新动态',
          author: '张三',
          content: '今天区块链又有新的发展趋势，需要关注市场变化...',
          likes: 12,
          comments: 3,
          rank: 2,
        ),
        ForumPostBlock(
          tagIcon: Icons.whatshot,
          title: '区块链最新动态',
          author: '张三',
          content: '今天区块链又有新的发展趋势，需要关注市场变化...',
          likes: 12,
          comments: 3,
          rank: 3,
        ),
        ForumPostBlock(
          tagIcon: Icons.whatshot,
          title: '区块链最新动态',
          author: '张三',
          content: '今天区块链又有新的发展趋势，需要关注市场变化...',
          likes: 12,
          comments: 3,
          rank: 4,
        ),
        ForumPostBlock(
          tagIcon: Icons.lightbulb,
          title: '心得分享：Flutter布局经验',
          author: '李四',
          content: '在实际开发中，使用Row+Column可以更好地处理复杂布局...',
          likes: 8,
          comments: 2,
          rank: 5,
        ),
        // 更多帖子...
      ],
    ),
  ),
)
          
              ],
            ),
          ),
      
    );
  }
  }
