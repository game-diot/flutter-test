import 'package:flutter/material.dart';
import '../components/navbar.dart';
import '../news_page/news.dart';
import 'header/header.dart';
import 'container/carousel_section.dart';
import 'container/row_section.dart';
import 'container/data_section.dart';
import '../add_page/add.dart';
import '../forum_page/forum.dart';
import '../setting_page/setting.dart';
import 'models/symbol_item.dart';
import 'services/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<SymbolItem> _coinList = [];
  bool _isLoading = true;

  // 页面列表 - 初始化为空列表，避免 late 初始化问题
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _initializePages(); // 先初始化页面
    _fetchCoinList(); // 再获取数据
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _fetchCoinList() async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<SymbolItem> coins = await ApiService.fetchSymbols();

      setState(() {
        _coinList = coins;
        _isLoading = false;
      });

      // 数据加载完成后更新页面列表
      _initializePages();
    } catch (e) {
      print('加载 coinList 失败: $e');
      setState(() {
        _isLoading = false;
      });
      // 即使出错也要初始化页面
      _initializePages();
    }
  }

  void _initializePages() {
    setState(() {
      _pages = [
        _buildMarketPage(), // 行情页
        NewsPage(), // 新闻页
        AddPage(), // 新增页
        ForumPage(), // 论坛页
        SettingPage(), // 设置页
      ];
    });
  }

  // 原行情首页布局
  Widget _buildMarketPage() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          // Header 区域
          Container(
            color: Color.fromRGBO(237, 176, 35, 1),
            child: Column(children: [Header(), SizedBox(height: 10)]),
          ),

          SizedBox(height: 10),

          // 广告图
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // 设置圆角
                child: SizedBox(
                  width: 380,
                  height: 150,
                  child: Image.asset(
                    'assets/images/行情页广告图.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: Text('图片加载失败')),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // 全球指数标题
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

          // 轮播图 - 只保留一个
          Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: _isLoading
                ? Container(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SymbolCarousel(coinList: _coinList),
          ),

          SizedBox(height: 10),

          // 行情资讯横条
          Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: RowSection(),
          ),

          SizedBox(height: 10),

          // 数据表格区域
          Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: _isLoading
                ? Container(
                    height: 400,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : DataSection(coinList: _coinList),
          ),
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
      body: _pages.isNotEmpty
          ? _pages[_currentIndex]
          : Center(child: CircularProgressIndicator()), // 根据 currentIndex 显示页面
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
