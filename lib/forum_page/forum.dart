// lib/pages/forum_page.dart
import 'package:flutter/material.dart';
import 'header/header.dart'; // 引入 ForumHeader 组件
import '../components/navbar.dart'; // 引入 Navbar 组件

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int _selectedIndex = 3; // 初始选中论坛页面

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index; // 更新选中的文字
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('论坛页面'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 引入 ForumHeader 组件
          ForumHeader(),
          
          // 其他内容部分
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    color: Colors.blue[50],
                    child: Text('这里是论坛内容，展示帖子等信息'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
        onTabSelected: _onTabSelected,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
