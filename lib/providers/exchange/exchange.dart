// providers/exchange_rate_provider.dart
import 'package:flutter/material.dart';
import '../../socket/home_page_data_section/exchange_rate_model.dart';
import '../../socket/home_page_data_section/services.dart';
class ExchangeRateProvider extends ChangeNotifier {
  final ExchangeWebSocketService _wsService = ExchangeWebSocketService();

  List<ExchangeRateData> _data = [];
  Map<String, ExchangeRateData> _exchangeRateMap = {}; // 🔹 新增映射

  List<ExchangeRateData> get data => _data;
  Map<String, ExchangeRateData> get exchangeRateMap => _exchangeRateMap;

  String _sortField = 'symbol';
  bool _ascending = true;

  ExchangeRateProvider() {
    // 监听 WebSocket 数据
    _wsService.rateStream.listen((response) {
      _updateData(response.data);
    });
    _wsService.connect();
  }

  // 排序后的列表
  List<ExchangeRateData> get filteredData {
    List<ExchangeRateData> list = List.from(_data);
    list.sort((a, b) {
      dynamic valueA;
      dynamic valueB;
      switch (_sortField) {
        case 'symbol':
          valueA = a.symbol;
          valueB = b.symbol;
          break;
        case 'price':
          valueA = a.price;
          valueB = b.price;
          break;
        case 'change':
          valueA = a.percentChange;
          valueB = b.percentChange;
          break;
        case 'volume':
          valueA = a.volume ?? 0.0;
          valueB = b.volume ?? 0.0;
          break;
        default:
          valueA = a.symbol;
          valueB = b.symbol;
      }

      if (_ascending) {
        return (valueA).compareTo(valueB);
      } else {
        return (valueB).compareTo(valueA);
      }
    });
    return list;
  }

  void _updateData(List<ExchangeRateData> newData) {
    _data = newData;

    // 🔹 更新映射
    _exchangeRateMap.clear();
    for (var rate in newData) {
      _exchangeRateMap[rate.symbol] = rate;
    }

    // 🔹 如果需要额外处理合并逻辑，可以调用类似 _updateCombinedData()
    // _updateCombinedData();

    notifyListeners();
  }

  void setSorting(String field, {bool ascending = true}) {
    _sortField = field;
    _ascending = ascending;
    notifyListeners();
  }

  ExchangeRateData? getDataForSymbol(String symbol) {
    return _exchangeRateMap[symbol];
  }

  @override
  void dispose() {
    _wsService.dispose();
    super.dispose();
  }
}
