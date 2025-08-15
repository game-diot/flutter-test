import 'package:flutter/material.dart';
import 'header/header.dart'; // 引入 NewsHeader 页面
import '../components/navbar.dart'; // 引入 Navbar 组件

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _currentIndex = 1; // 初始选中的是 '新闻' 页面

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index; // 更新选中的 tab
    });
  }

  // 文字块轮播图
  Widget buildTextCarouselItem(String text) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blue[100], // 背景色
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // 内容块
  Widget buildContentBlock(BuildContext context, String title) {
    double screenWidth = MediaQuery.of(context).size.width; // 获取屏幕宽度
    return Container(
      width: screenWidth, // 设置宽度为设备的宽度
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // 上下间距
      padding: EdgeInsets.all(20), // 内边距
      decoration: BoxDecoration(
        color: Colors.blue[50], // 块背景色
        borderRadius: BorderRadius.circular(10), // 圆角
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)], // 阴影效果
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.blue[800]),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新闻页面'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 引入 NewsHeader 组件
          NewsHeader(),
          
          // 文字块轮播图部分
          Container(
            height: 100, // 文字块轮播图的高度
            child: PageView(
              children: [
                buildTextCarouselItem('最新新闻：第一条新闻内容'),
                buildTextCarouselItem('热点新闻：第二条新闻内容'),
                buildTextCarouselItem('今日头条：第三条新闻内容'),
                buildTextCarouselItem('世界新闻：第四条新闻内容'),
              ],
            ),
          ),

          // 下面是其他新闻页面的内容
          Expanded(
            child: SingleChildScrollView( // 使内容可以滚动
              child: Column(
                children: [
                  buildContentBlock(context, '区块1：最新新闻'),
                  buildContentBlock(context, '区块2：热评新闻'),
                  buildContentBlock(context, '区块3：国际新闻'),
                  buildContentBlock(context, '区块4：科技新闻'),
                  buildContentBlock(context, '区块5：财经新闻'),
                ],
              ),
            ),
          ),
        ],
      ),
      // 引入 Navbar 组件
      bottomNavigationBar: Navbar(
        onTabSelected: _onTabSelected, // 传递回调
        currentIndex: _currentIndex, // 当前选中的 tab
      ),
    );
  }
}
