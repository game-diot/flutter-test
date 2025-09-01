import '../models/combined_coin_data.dart';
import '../../../../../socket/home_page_data_section/exchange_rate_model.dart';
import '../../../../../socket/home_page_data_section/services.dart';

class DataSectionService {
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

  void sortCombinedData(
    List<CombinedCoinData> data,
    String key,
    bool ascending,
  ) {
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
          if (a.priceChangePercent == null && b.priceChangePercent == null)
            return 0;
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
