import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import '../../../../providers/exchange/exchange.dart';
import '../../../../network/Get/models/home_page/home_data_section.dart';
import '../../../../socket/home_page_data_section/models.dart';
import '../../../../localization/lang.dart';

// 导入拆分后的组件
import 'models/combined_coin_data.dart';
import 'services/data_section_service.dart';
import 'components/data_section_header.dart';
import 'components/combined_table.dart';
import '../../../coin_detail_page/coin_detail_page.dart';

/// 主数据区域组件
class DataSection extends StatefulWidget {
  final List<SymbolItem>? coinList;
  final bool? isLoading;

  const DataSection({Key? key, this.coinList, this.isLoading})
      : super(key: key);

  @override
  _DataSectionState createState() => _DataSectionState();
}

class _DataSectionState extends State<DataSection> {
  int _selectedIndex = 0;
  late DataSectionService _dataSectionService;
  Map<String, ExchangeRateData> _exchangeRateMap = {};
  List<CombinedCoinData> _combinedData = [];

  Map<String, bool> _sortAscCoin = {'名称': true, '价格': true, '涨幅比': true};

  // 保存当前排序状态
  String _currentSortKey = '名称';
  bool _currentSortAsc = true;

  @override
  void initState() {
    super.initState();
    _dataSectionService = DataSectionService();
    _initWebSocket();
    _updateCombinedData();
  }

  void _initWebSocket() {
    _dataSectionService.initWebSocket();

    _dataSectionService.exchangeRateStream?.listen((exchangeRateMap) {
      if (!mounted) return;

      setState(() {
        _exchangeRateMap = exchangeRateMap;
        _updateCombinedData();
      });
    });
  }

  void _updateCombinedData() {
    if (widget.coinList == null) return;

    _combinedData = widget.coinList!.map((symbolItem) {
      final wsSymbol = symbolItem.symbol.replaceAll('_', '~');

      final prevData = _combinedData.firstWhere(
        (e) => e.symbol == symbolItem.symbol,
        orElse: () => CombinedCoinData.fromSymbolItem(symbolItem),
      );

      final exchangeRate =
          _exchangeRateMap[wsSymbol] ?? _exchangeRateMap[symbolItem.symbol];

      if (exchangeRate != null) {
        return CombinedCoinData(
          symbolId: symbolItem.symbolId,
          symbol: symbolItem.symbol,
          baseSymbol: symbolItem.baseSymbol,
          alias: symbolItem.alias,
          icon1: symbolItem.icon1,
          currentPrice: exchangeRate.price,
          priceChangePercent: exchangeRate.percentChange,
          priceChangeAmount: exchangeRate.priceChange,
          hasRealTimeData: true,
        );
      } else {
        return prevData;
      }
    }).toList();

    // **重新应用排序**
    if (_currentSortKey.isNotEmpty) {
      _dataSectionService.sortCombinedData(_combinedData, _currentSortKey, _currentSortAsc);
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(DataSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coinList != widget.coinList) {
      _updateCombinedData();
    }
  }

  @override
  void dispose() {
    _dataSectionService.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSortCombinedData(String key) {
    setState(() {
      bool ascending = _sortAscCoin[key]!;
      _dataSectionService.sortCombinedData(_combinedData, key, ascending);
      _sortAscCoin[key] = !ascending;

      // 保存当前排序状态
      _currentSortKey = key;
      _currentSortAsc = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    final textColor = isLight ? Colors.black : Colors.white;
    final subTextColor = isLight ? Colors.grey[700] : Colors.grey[400];

    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isLight ? Colors.white : const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataSectionHeader(
            selectedIndex: _selectedIndex,
            onTabChanged: _onTabChanged,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<ExchangeRateProvider>(
              builder: (context, provider, _) {
                return _buildTableContent(provider, textColor, subTextColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent(
    ExchangeRateProvider provider,
    Color textColor,
    Color? subTextColor,
  ) {
    if (widget.coinList != null && _selectedIndex == 0) {
      final translatedSortKeys = {
        Lang.t('name'): _sortAscCoin['名称']!,
        Lang.t('price'): _sortAscCoin['价格']!,
        Lang.t('price_change_percent'): _sortAscCoin['涨幅比']!,
      };

      return CombinedTable(
        data: _combinedData,
        isLoading: widget.isLoading == true,
        sortAscending: translatedSortKeys,
        onSort: (key) {
          final originalKeyMap = {
            Lang.t('name'): '名称',
            Lang.t('price'): '价格',
            Lang.t('price_change_percent'): '涨幅比',
          };
          _onSortCombinedData(originalKeyMap[key]!);
        },
        textColor: textColor,
        subTextColor: subTextColor,
        // 点击单行 → 跳转
        onRowTap: (coin) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SocketBindPage(coin: coin),
            ),
          );
        },
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Lang.t('no_data'), style: TextStyle(color: textColor, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            Lang.t('switch_other_tab'),
            style: TextStyle(color: subTextColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}