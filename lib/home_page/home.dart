import 'package:flutter/material.dart';
import '../components/navbar.dart';
import '../news_page/news.dart';
import 'header/header.dart';
import 'container/carousel_secttion.dart';
import 'container/row_section.dart';
import 'container/data_section.dart';
import '../add_page/add.dart';
import '../forum_page/forum.dart';
import '../setting_page/setting.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // 页面列表
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // 初始化页面列表
    _pages.addAll([
      _buildMarketPage(), // 行情页
      NewsPage(),         // 新闻页
      AddPage(),          // 新增页
      ForumPage(),        // 论坛页
      SettingPage(),      // 设置页
    ]);
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // 原行情首页布局
  Widget _buildMarketPage() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [

          Container(
                     color: Color.fromRGBO(237, 176, 35, 1),
            child: Column(
              children:[
                Header(),
                SizedBox(height: 10,),
              ],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 150,
            width: 350,
            child: Image.asset(
              'assets/images/行情页广告图.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '全球指数',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: CarouselSection(),
          ),
          SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: RowSection(),
          ),
          SizedBox(height: 10),
          DataSection(),
        ],
      ),
    );
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      toolbarHeight: 0, // 高度可调
      backgroundColor: Color.fromARGB(255, 237, 176, 35), // 纯色
      elevation: 0, // 去掉阴影
    ),
    body: _pages[_currentIndex], // 根据 currentIndex 显示页面
    bottomNavigationBar: Navbar(
      currentIndex: _currentIndex,
      onTabSelected: _onTabSelected,
    ),
  );
}
}