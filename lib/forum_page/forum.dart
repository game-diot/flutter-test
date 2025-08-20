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
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor = isDark ? Colors.grey[850]! : Colors.white;
    Color borderColor = isSelected
        ? Color.fromRGBO(237, 176, 35, 1)
        : (isDark ? Colors.grey[700]! : Colors.grey);
    Color iconColor = isSelected
        ? Color.fromRGBO(237, 176, 35, 1)
        : (isDark ? Colors.white : Colors.black);
    Color textColor = isDark ? Colors.white : Colors.black;
    Color bottomBarColor = isSelected
        ? Color.fromRGBO(237, 176, 35, 1)
        : Colors.transparent;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFunctionIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: iconColor),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 4),
            Container(width: 40, height: 2, color: bottomBarColor),
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
            ),
          ],
        ),
      ),
    );
  }
}
