// providers/exchange_rate_provider.dart
import 'package:flutter/material.dart';
import '../../Websocket/home_page_data_section/models.dart';
import '../../Websocket/home_page_data_section/services.dart';
// providers/exchange_rate_provider.dart
class ExchangeRateProvider extends ChangeNotifier {
  final ExchangeRateWebSocketService _wsService = ExchangeRateWebSocketService();

  List<ExchangeRateData> _data = [];
  List<ExchangeRateData> get data => _data;

  String _sortField = 'symbol';
  bool _ascending = true;

  ExchangeRateProvider() {
    // 初始化 WebSocket
    _wsService.dataStream.listen((response) {
      _updateData(response.data);
    });
    _wsService.connect();
  }

  List<ExchangeRateData> get filteredData {
    List<ExchangeRateData> list = List.from(_data);
    // 排序逻辑
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
    // 可以做增量更新或覆盖更新
    _data = newData;
    notifyListeners();
  }

  void setSorting(String field, {bool ascending = true}) {
    _sortField = field;
    _ascending = ascending;
    notifyListeners();
  }

  // 🔹 新增方法：根据 symbol 获取单条数据
  ExchangeRateData? getDataForSymbol(String symbol) {
    try {
      return _data.firstWhere((element) => element.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _wsService.dispose();
    super.dispose();
  }
}
