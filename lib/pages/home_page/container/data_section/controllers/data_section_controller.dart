import 'package:flutter/material.dart';
import '../../../../../network/Get/models/home_page/home_data_section.dart';
import '../../../../../socket/home_page_data_section/models.dart';
import '../services/data_section_service.dart';
import '../models/combined_coin_data.dart';

class DataSectionController extends ChangeNotifier {
  final DataSectionService _dataSectionService = DataSectionService();

  int _selectedIndex = 0;
  Map<String, ExchangeRateData> _exchangeRateMap = {};
  List<CombinedCoinData> _combinedData = [];
  List<SymbolItem>? _coinList;
  Map<String, bool> _sortAscCoin = {'名称': true, '价格': true, '涨幅比': true};
  String _currentSortKey = '名称';
  bool _currentSortAsc = true;

  // Getters
  int get selectedIndex => _selectedIndex;
  List<CombinedCoinData> get combinedData => _combinedData;
  Map<String, bool> get sortAscCoin => _sortAscCoin;
  String get currentSortKey => _currentSortKey;
  bool get currentSortAsc => _currentSortAsc;

  void initWebSocket() {
    _dataSectionService.initWebSocket();
    _dataSectionService.exchangeRateStream?.listen((exchangeRateMap) {
      _exchangeRateMap = exchangeRateMap;
      _updateCombinedDataInternal();
    });
  }

  void _updateCombinedDataInternal() {
    // 重新构建合并数据
    if (_coinList != null) {
      _buildCombinedData(_coinList!);
    }
    notifyListeners();
  }

  void dispose() {
    _dataSectionService.dispose();
    super.dispose();
  }

  void onTabChanged(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void updateCombinedData(List<SymbolItem>? coinList) {
    _coinList = coinList;
    if (coinList == null) return;
    _buildCombinedData(coinList);
    notifyListeners();
  }

  void _buildCombinedData(List<SymbolItem> coinList) {
    _combinedData = coinList.map((symbolItem) {
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

    if (_currentSortKey.isNotEmpty) {
      _dataSectionService.sortCombinedData(
        _combinedData,
        _currentSortKey,
        _currentSortAsc,
      );
    }
  }

  void onSortCombinedData(String key) {
    bool ascending = _sortAscCoin[key]!;
    _dataSectionService.sortCombinedData(_combinedData, key, ascending);
    _sortAscCoin[key] = !ascending;
    _currentSortKey = key;
    _currentSortAsc = ascending;
    notifyListeners();
  }
}
