
// ==========================================
// lib/home_page/symbol_carousel/services/chart_data_service.dart
// ==========================================

import '../../../../../../socket/home_page_data_section/models.dart';
import '../../../../../../socket/home_page_data_section/services.dart';

/// 图表数据服务类，负责处理WebSocket连接
class ChartDataService {
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
}