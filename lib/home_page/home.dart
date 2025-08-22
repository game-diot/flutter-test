import 'package:flutter/material.dart';
import 'components/navbar.dart';
import '../news_page/news.dart';
import '../add_page/add.dart';
import '../forum_page/forum.dart';
import '../setting_page/setting.dart';
import 'components/market_page.dart';
import 'components/appbar.dart';
import '../network/Get/models/home_page/home_data_section.dart';
import '../network/Get/services/home_page/home_data_section.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
      final coins = await ApiService.fetchSymbols();
      if (!mounted) return; // 避免 setState after dispose
      setState(() {
        _coinList = coins;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('加载 coinList 失败: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final pages = [
      MarketPage(coinList: _coinList, isLoading: _isLoading),
      NewsPage(),
      AddPage(),
      ForumPage(),
      SettingPage(),
    ];

    return Scaffold(
      appBar: HomeAppBar(currentIndex: _currentIndex), // ⬅️ 已拆分
      body: _isLoading && _currentIndex == 0
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : pages[_currentIndex],
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}
