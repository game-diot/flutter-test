// services/depth_data_service.dart
import '../../../../../socket/home_page_data_section/exchange_depth_model.dart';
import '../../../../../socket/home_page_data_section/services.dart';

class DepthDataService {
  ExchangeWebSocketService? _webSocketService;

  // 保存最新深度数据
  Map<String, ExchangeDepth> _exchangeDepthMap = {};

  // Stream 供 Controller 或 UI 监听
  Stream<Map<String, ExchangeDepth>>? get exchangeDepthStream =>
      _webSocketService?.depthStream.map((list) {
        _exchangeDepthMap.clear();
        for (final depth in list) {
          _exchangeDepthMap[depth.symbol] = depth;
        }
        return Map.from(_exchangeDepthMap);
      });

  /// 初始化 WebSocket
  void initWebSocket() {
    _webSocketService = ExchangeWebSocketService();
    _webSocketService?.connect();
  }

  /// 断开连接并释放资源
  void dispose() {
    _webSocketService?.disconnect();
  }

  /// 可选方法：订阅指定交易对深度
  void subscribeSymbol(String symbol) {
    _webSocketService?.subscribeToDepth(symbol);
  }

  /// 可选方法：取消订阅
  void unsubscribeSymbol(String symbol) {
    _webSocketService?.unsubscribeFromDepth(symbol);
  }

  /// 获取当前缓存的深度数据
  ExchangeDepth? getDepthBySymbol(String symbol) {
    return _exchangeDepthMap[symbol];
  }
}
