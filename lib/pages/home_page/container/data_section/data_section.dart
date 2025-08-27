
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import '../../../../providers/exchange/exchange.dart';
import '../../../../network/Get/models/home_page/home_data_section.dart';
import '../../../../socket/home_page_data_section/models.dart';

// 导入拆分后的组件
import 'models/combined_coin_data.dart';
import 'services/data_section_service.dart';
import 'components/data_section_header.dart';
import 'components/combined_table.dart';
import 'components/coin_table.dart';
import 'components/exchange_table.dart';

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
  Map<String, bool> _sortAscExchange = {'名称': true, '交易额': true, '评分': true};

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

    final exchangeRate = _exchangeRateMap[wsSymbol] ?? _exchangeRateMap[symbolItem.symbol];

    if (exchangeRate != null) {
      // 只更新有值的字段
      return CombinedCoinData(
        symbolId: symbolItem.symbolId,
        symbol: symbolItem.symbol,
        baseSymbol: symbolItem.baseSymbol,
        alias: symbolItem.alias,
        icon1: symbolItem.icon1,
        currentPrice: exchangeRate.price ,
        priceChangePercent: exchangeRate.percentChange ,
        priceChangeAmount: exchangeRate.priceChange ,
        hasRealTimeData: true,
      );
    } else {
      // WS 没返回数据，保留上次值
      return prevData;
    }
  }).toList();

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
    });
  }

  void _onSortCoin(String key, ExchangeRateProvider provider) {
    String sortBy = key == '名称'
        ? 'symbol'
        : key == '价格'
        ? 'price'
        : 'change';
    provider.setSorting(sortBy, ascending: _sortAscCoin[key]!);
    _sortAscCoin[key] = !_sortAscCoin[key]!;
  }

  void _onSortExchange(String key, ExchangeRateProvider provider) {
    String sortBy = key == '名称'
        ? 'symbol'
        : key == '交易额'
        ? 'volume'
        : 'change';
    provider.setSorting(sortBy, ascending: _sortAscExchange[key]!);
    _sortAscExchange[key] = !_sortAscExchange[key]!;
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
    // 如果有coinList数据且选择的是主流币，使用合并数据
    if (widget.coinList != null && _selectedIndex == 0) {
      return CombinedTable(
        data: _combinedData,
        isLoading: widget.isLoading == true,
        sortAscending: _sortAscCoin,
        onSort: _onSortCombinedData,
        textColor: textColor,
        subTextColor: subTextColor,
      );
    }

    // 否则使用原有逻辑
    final coinList = provider.filteredData.where((e) => e.isCrypto).toList();
    final exchangeList = provider.filteredData.where((e) => e.isForex).toList();

    if (_selectedIndex == 3 || _selectedIndex == 1 || _selectedIndex == 2) {
      return ExchangeTable(
        exchangeList: exchangeList,
        sortAscending: _sortAscExchange,
        onSort: _onSortExchange,
        textColor: textColor,
        subTextColor: subTextColor,
        provider: provider,
      );
    } else {
      return CoinTable(
        coinList: coinList,
        sortAscending: _sortAscCoin,
        onSort: _onSortCoin,
        textColor: textColor,
        subTextColor: subTextColor,
        provider: provider,
      );
    }
  }
}
