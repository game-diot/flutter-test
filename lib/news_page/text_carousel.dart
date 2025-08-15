import 'package:flutter/material.dart';
import 'header/header.dart'; // 引入 NewsHeader 页面

class NewsPage extends StatelessWidget {
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

          // 下面是新闻页面的内容
          Expanded(
            child: Center(
              child: Text(
                '这里是新闻页面的内容',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建文字块
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
}
