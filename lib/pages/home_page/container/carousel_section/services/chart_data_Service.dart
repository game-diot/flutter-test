import '../../../../../socket/home_page_data_section/exchange_rate_model.dart';
import '../../../../../socket/home_page_data_section/services.dart';

class ChartDataService {
  ExchangeWebSocketService? _webSocketService;
  Map<String, ExchangeRateData> _exchangeRateMap = {};

  Stream<Map<String, ExchangeRateData>>? get exchangeRateStream =>
      _webSocketService?.rateStream.map((response) {
        _exchangeRateMap.clear();
        for (final rate in response.data) {
          _exchangeRateMap[rate.symbol] = rate;
        }
        return Map.from(_exchangeRateMap);
      });

  void initWebSocket() {
    _webSocketService = ExchangeWebSocketService();
    _webSocketService?.connect();
  }

  void dispose() {
    _webSocketService?.disconnect();
  }
}
