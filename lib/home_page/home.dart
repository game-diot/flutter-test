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

  @override
  void initState() {
    super.initState();
    _fetchCoinList(); // 数据请求在 initState 中
  }

  Future<void> _fetchCoinList() async {
    try {
      setState(() => _isLoading = true);
      List<SymbolItem> coins = await ApiService.fetchSymbols();
      setState(() {
        _coinList = coins;
        _isLoading = false;
      });
    } catch (e) {
      print('加载 coinList 失败: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 页面列表，这里延迟调用 _buildMarketPage，保证 Theme 可用
    final List<Widget> pages = [
      _buildMarketPage(theme, isDark),
      NewsPage(),
      AddPage(),
      ForumPage(),
      SettingPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: _isLoading && _currentIndex == 0
          ? Center(child: CircularProgressIndicator())
          : pages[_currentIndex],
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }

  Widget _buildMarketPage(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          // Header 区域
          Container(color: theme.primaryColor, child: Column(children: [Header(), SizedBox(height: 10)])),

          // 广告图
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 380,
                height: 150,
                child: Image.asset(
                  'assets/images/行情页广告图.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                    child: Center(
                      child: Text(
                        '图片加载失败',
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '全球指数',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ),

          SizedBox(height: 10),
          Container(
            color: theme.cardColor,
            child: _isLoading
                ? Container(height: 150, child: Center(child: CircularProgressIndicator()))
                : SymbolCarousel(coinList: _coinList),
          ),

          SizedBox(height: 10),
          Container(color: theme.cardColor, child: RowSection()),

          SizedBox(height: 10),
          Container(
            color: theme.cardColor,
            child: _isLoading
                ? Container(height: 400, child: Center(child: CircularProgressIndicator()))
                : DataSection(coinList: _coinList),
          ),
        ],
      ),
    );
  }
}
