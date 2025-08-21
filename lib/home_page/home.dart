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
  const HomePage({super.key});

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
    _fetchCoinList();
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 根据页面和主题动态设置 AppBar 背景
    if (_currentIndex == 4) {
      // Setting 页面固定深色
      return AppBar(toolbarHeight: 0, backgroundColor: const Color.fromRGBO(81, 63, 41, 1), elevation: 0);
    } else {
      return AppBar(
        toolbarHeight: 0,
        backgroundColor: isDark
            ? const Color.fromRGBO(18, 18, 18, 1) // 暗色背景
            : const Color.fromRGBO(237, 176, 35, 1), // 明亮背景
        elevation: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final pages = [
      _buildMarketPage(theme),
      NewsPage(),
      AddPage(),
      ForumPage(),
      SettingPage(),
    ];

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _isLoading && _currentIndex == 0
          ? Center(
              child: CircularProgressIndicator(color: theme.colorScheme.primary),
            )
          : pages[_currentIndex],
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }

  Widget _buildMarketPage(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          // Header 区域
          Container(
            color: isDark ? const Color.fromRGBO(18,18 ,18, 1) : const Color.fromRGBO(237, 176, 35, 1),
            child: const Column(children: [Header(), SizedBox(height: 10)]),
          ),
          const SizedBox(height: 10),

          // 广告图
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
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
          const SizedBox(height: 10),

          // 全球指数标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '全球指数',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Carousel 区块
          Container(
            color: theme.cardColor,
            child: _isLoading
                ? SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
                  )
                : SymbolCarousel(coinList: _coinList),
          ),
          const SizedBox(height: 10),

          // RowSection 区块
          Container(color: theme.cardColor, child: RowSection()),
          const SizedBox(height: 10),

          // DataSection 区块
          Container(
            color: theme.cardColor,
            child: _isLoading
                ? SizedBox(
                    height: 400,
                    child: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
                  )
                : DataSection(coinList: _coinList),
          ),
        ],
      ),
    );
  }
}
