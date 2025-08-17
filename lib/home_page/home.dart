import 'package:flutter/material.dart';
import '../components/navbar.dart'; // 导入 Navbar
import 'header/header.dart'; // 导入 Header
import 'container/carousel_secttion.dart'; // 引入 CarouselSection
import 'container/row_section.dart'; // 引入 RowSection
import 'container/data_section.dart'; // 引入 DataSection

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // 当前选中的 tab

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index; // 更新选中的 tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Navbar Demo')),
      body: Column(
        children: [
          Header(), // 引入 Header 组件
          Image.asset(
            'lib/assert/行情页广告图.png', // 替换为你的图片路径

            fit: BoxFit.cover, // 确保图片适应容器
          ),
          // 文字描述部分
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '全球指数',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          CarouselSection(), // 引入 CarouselSection 组件
          SizedBox(height: 10), // 添加间距
          RowSection(), // 引入 RowSection 组件
          DataSection(), // 引入 DataSection 组件
          Expanded(child: Center(child: Text('首页内容'))),
        ],
      ),
      bottomNavigationBar: Navbar(
        onTabSelected: _onTabSelected, // 传递回调
        currentIndex: _currentIndex, // 当前选中的 tab
      ),
    );
  }
}
