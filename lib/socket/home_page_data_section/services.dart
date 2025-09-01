// services/exchange_websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'exchange_rate_model.dart';
import 'exchange_depth_model.dart';

class ExchangeWebSocketService {
  static const String _wsUrl =
      'wss://us15-h5.yanshi.lol/app-websocket?Authorization=87fcde66607c4e319f4e757a61fc6081&version=v1';

  WebSocketChannel? _channel;
  Timer? _reconnectTimer;

  // 流控制器
  final _connectionController = StreamController<bool>.broadcast();
  final _rateController = StreamController<ExchangeRateResponse>.broadcast();
  final _depthController = StreamController<List<ExchangeDepth>>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  // 连接状态
  bool _isConnected = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  static const Duration _reconnectDelay = Duration(seconds: 5);

  // 流 getters
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<ExchangeRateResponse> get rateStream => _rateController.stream;
  Stream<List<ExchangeDepth>> get depthStream => _depthController.stream;
  Stream<String> get errorStream => _errorController.stream;
  bool get isConnected => _isConnected;

  /// 连接 WebSocket
  Future<void> connect() async {
    if (_isConnected) return;
    _shouldReconnect = true;
    await _connectInternal();
  }

  /// 内部连接方法
  Future<void> _connectInternal() async {
    try {
      print('尝试连接 WebSocket: $_wsUrl');

      _channel = IOWebSocketChannel.connect(Uri.parse(_wsUrl));

      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDisconnected,
        cancelOnError: false,
      );

      _onConnected();
    } catch (e) {
      _onError('WebSocket连接异常: $e');
    }
  }

  /// 连接成功回调
  void _onConnected() {
    print('WebSocket 连接成功');
    _isConnected = true;
    _reconnectAttempts = 0;
    _connectionController.add(true);

    // 默认订阅交易对
    sendMessage({
      "type": "SUB",
      "data": [
        "BTC~USDT",
        "ETH~USDT",
        "BNB~USDT",
        "SOL~USDT",
        "DOGE_USDT",
        "TRX_USDT",
        "TAO~USDT",
        "TON~USDT",
        "IOTX_USDT",
        "ADA_USDT",
        "DYDX_USDT",
        "XRP~USDT",
        "WBTC_USDT",
        "DOT~USDT",
        "FARM_USDT",
        "TESTUSDC",
        "GBP/USD",
      ],
    });
  }
/// 订阅单个交易对的盘口数据
  void subscribeToDepth(String symbol) {
    // print('🔧 [WebSocket] Subscribing to depth for: $symbol');
    sendMessage({
      'type': 'SUB_DEPTH',
      'data': symbol  // 注意：这里是字符串，不是数组
    });
  }
  
  /// 取消订阅盘口数据
  void unsubscribeFromDepth(String symbol) {
    // print('🔧 [WebSocket] Unsubscribing from depth for: $symbol');
    sendMessage({
      'type': 'UNSUB_DEPTH',
      'data': symbol
    });
  }

  /// 接收消息回调 - 需要处理 EXCHANGE_DEPTH
  void _onMessage(dynamic message) {
    // print('📨 [WebSocket] Raw message: $message');
    try {
      final Map<String, dynamic> json = jsonDecode(message.toString());
      // print('📨 [WebSocket] Message type: ${json['type']}');
      final type = json['type'] ?? '';
      final data = json['data'];

      if (type == 'EXCHANGE_RATE' && data is List) {
        final rates = data
            .map((item) => ExchangeRateData.fromJson(item as Map<String, dynamic>))
            .toList();
        if (rates.isNotEmpty) {
          _rateController.add(ExchangeRateResponse(type: type, data: rates));
        }
      } else if (type == 'EXCHANGE_DEPTH') {
        // 🔧 处理盘口数据
        // print('✅ [WebSocket] Received depth data');
        _processDepthData(data);
      }
    } catch (e) {
      print('解析消息失败: $e');
      _errorController.add('数据解析错误: $e');
    }
  }
void _processDepthData(dynamic data) {
    try {
      List<ExchangeDepth> depths = [];
      
      if (data is Map<String, dynamic>) {
        // 单个盘口数据
        depths.add(ExchangeDepth.fromJson(data));
      } else if (data is List) {
        // 多个盘口数据
        depths = data
            .map((item) => ExchangeDepth.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      
      if (depths.isNotEmpty) {
        _depthController.add(depths);
        print('✅ [WebSocket] Processed ${depths.length} depth items');
      }
    } catch (e) {
      print('❌ [WebSocket] Process depth error: $e');
    }
  }
  /// 错误处理
  void _onError(dynamic error) {
    print('WebSocket错误: $error');
    _errorController.add(error.toString());

    if (_isConnected) {
      _onDisconnected();
    }
  }

  /// 连接断开
  void _onDisconnected() {
    print('WebSocket连接断开');
    _isConnected = false;
    _connectionController.add(false);

    if (_shouldReconnect && _reconnectAttempts < _maxReconnectAttempts) {
      _scheduleReconnect();
    } else if (_reconnectAttempts >= _maxReconnectAttempts) {
      _errorController.add('达到最大重连次数，连接已停止');
    }
  }

  /// 计划重连
  void _scheduleReconnect() {
    _reconnectAttempts++;
    print(
      '计划重连 ($_reconnectAttempts/$_maxReconnectAttempts) 在 ${_reconnectDelay.inSeconds} 秒后',
    );
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_shouldReconnect) _connectInternal();
    });
  }

  /// 发送消息
  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      try {
        _channel!.sink.add(jsonEncode(message));
        print('发送消息: $message');
      } catch (e) {
        _errorController.add('发送消息失败: $e');
      }
    } else {
      _errorController.add('连接未建立，无法发送消息');
    }
  }



  /// 断开连接
  void disconnect() {
    print('断开 WebSocket 连接');
    _shouldReconnect = false;
    _reconnectTimer?.cancel();

    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }

    if (_isConnected) {
      _isConnected = false;
      _connectionController.add(false);
    }
  }

  /// 重置
  void reset() {
    disconnect();
    _reconnectAttempts = 0;
  }

  /// 释放资源
  void dispose() {
    disconnect();
    _connectionController.close();
    _rateController.close();
    _depthController.close();
    _errorController.close();
  }

  /// 连接状态统计
  Map<String, dynamic> getConnectionStats() {
    return {
      'isConnected': _isConnected,
      'reconnectAttempts': _reconnectAttempts,
      'maxReconnectAttempts': _maxReconnectAttempts,
      'shouldReconnect': _shouldReconnect,
    };
  }
}
