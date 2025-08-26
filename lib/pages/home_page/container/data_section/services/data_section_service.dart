
// ==========================================
// lib/home_page/data_section/services/data_section_service.dart
// ==========================================

import '../../../../../socket/home_page_data_section/models.dart';
import '../../../../../socket/home_page_data_section/services.dart';
import '../../../../../network/Get/models/home_page/home_data_section.dart';
import '../models/combined_coin_data.dart';

/// 数据区域服务类，负责处理WebSocket连接和数据合并
class DataSectionService {
  ExchangeRateWebSocketService? _webSocketService;
  Map<String, ExchangeRateData> _exchangeRateMap = {};
  
  Stream<Map<String, ExchangeRateData>>? get exchangeRateStream => 
      _webSocketService?.dataStream.map((response) {
        _exchangeRateMap.clear();
        for (final rate in response.data) {
          _exchangeRateMap[rate.symbol] = rate;
        }
        return Map.from(_exchangeRateMap);
      });

  void initWebSocket() {
    _webSocketService = ExchangeRateWebSocketService();
    _webSocketService?.connect();
  }

  void dispose() {
    _webSocketService?.disconnect();
  }

  /// 合并基础数据和实时数据
  List<CombinedCoinData> combineData(
    List<SymbolItem> symbolItems,
    Map<String, ExchangeRateData> exchangeRateMap,
  ) {
    return symbolItems.map((symbolItem) {
      final baseData = CombinedCoinData.fromSymbolItem(symbolItem);
      final exchangeRate = exchangeRateMap[symbolItem.symbol];
      
      return exchangeRate != null 
          ? baseData.updateWithRealTimeData(exchangeRate)
          : baseData;
    }).toList();
  }

  /// 排序合并数据
  void sortCombinedData(List<CombinedCoinData> data, String key, bool ascending) {
    data.sort((a, b) {
      int result;
      switch (key) {
        case '名称':
          result = a.displayName.compareTo(b.displayName);
          break;
        case '价格':
          if (a.currentPrice == null && b.currentPrice == null) return 0;
          if (a.currentPrice == null) return 1;
          if (b.currentPrice == null) return -1;
          result = a.currentPrice!.compareTo(b.currentPrice!);
          break;
        case '涨幅比':
          if (a.priceChangePercent == null && b.priceChangePercent == null) return 0;
          if (a.priceChangePercent == null) return 1;
          if (b.priceChangePercent == null) return -1;
          result = a.priceChangePercent!.compareTo(b.priceChangePercent!);
          break;
        default:
          return 0;
      }
      return ascending ? result : -result;
    });
  }
}
