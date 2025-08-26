// services/exchange_rate_websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'models.dart';

class ExchangeRateWebSocketService {
  static const String _wsUrl =
      'wss://us14-h5.yanshi.lol/app-websocket?Authorization=db3aa6c8667b4295b4a7c0f5ea270933&version=v1';

  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  // 流控制器
  final _connectionController = StreamController<bool>.broadcast();
  final _dataController = StreamController<ExchangeRateResponse>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  // 连接状态
  bool _isConnected = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const Duration _heartbeatInterval = Duration(seconds: 30);

  // 流getters
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<ExchangeRateResponse> get dataStream => _dataController.stream;
  Stream<String> get errorStream => _errorController.stream;

  bool get isConnected => _isConnected;

  // 连接WebSocket
  Future<void> connect() async {
    if (_isConnected) return;

    _shouldReconnect = true;
    await _connectInternal();
  }

  // 内部连接方法
  Future<void> _connectInternal() async {
    try {
      print('尝试连接WebSocket: $_wsUrl');

      _channel = IOWebSocketChannel.connect(
        Uri.parse(_wsUrl),
        protocols: ['websocket'],
      );

      // 监听连接状态
      _channel!.ready
          .then((_) {
            _onConnected();
          })
          .catchError((error) {
            _onError('连接失败: $error');
          });

      // 监听消息
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDisconnected,
        cancelOnError: false,
      );
    } catch (e) {
      _onError('WebSocket连接异常: $e');
    }
  }

  // 连接成功回调
  void _onConnected() {
    print('WebSocket连接成功');
    _isConnected = true;
    _reconnectAttempts = 0;
    _connectionController.add(true);

    // 开始心跳检测
    _startHeartbeat();

    sendMessage({
      "type": "SUB",
      "data": [
        "BTC~USDT",
        "ETH~USDT",
        "BNB~USDT",
        "DASH~USDT",
        "SOL~USDT",
        "AVAX~USDT",
        "TAO~USDT",
        "INJ_USDT",
        "LTC_USDT",
        "XRP~USDT",
        "WBTC_USDT",
        "DOT~USDT",
        "FARM_USDT",
        "TESTUSDC",
        "GBP/USD",
      ],
    });
  }

  // 消息接收回调
  void _onMessage(dynamic message) {
    try {
      final String messageStr = message.toString();
      print('收到WebSocket消息: $messageStr');

      final Map<String, dynamic> json = jsonDecode(messageStr);

      if ("EXCHANGE_RATE" == json["type"]) {
        List<ExchangeRateData> list =
            (json["data"] as List<dynamic>?)
                ?.map(
                  (item) =>
                      ExchangeRateData.fromJson(item as Map<String, dynamic>),
                )
                .toList() ??
            [];
        if (list.isNotEmpty) {
          _dataController.add(
            ExchangeRateResponse(type: json["type"], data: list),
          );
        }
      }
    } catch (e) {
      print('解析消息失败: $e');
      _errorController.add('数据解析错误: $e');
    }
  }

  // 错误处理回调
  void _onError(dynamic error) {
    print('WebSocket错误: $error');
    _errorController.add(error.toString());

    if (_isConnected) {
      _onDisconnected();
    }
  }

  // 连接断开回调
  void _onDisconnected() {
    print('WebSocket连接断开');
    _isConnected = false;
    _connectionController.add(false);

    // 停止心跳
    _stopHeartbeat();

    // 尝试重连
    if (_shouldReconnect && _reconnectAttempts < _maxReconnectAttempts) {
      _scheduleReconnect();
    } else if (_reconnectAttempts >= _maxReconnectAttempts) {
      _errorController.add('达到最大重连次数，连接已停止');
    }
  }

  // 计划重连
  void _scheduleReconnect() {
    _reconnectAttempts++;
    print(
      '计划重连 ($_reconnectAttempts/$_maxReconnectAttempts) 在 ${_reconnectDelay.inSeconds} 秒后',
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_shouldReconnect) {
        _connectInternal();
      }
    });
  }

  // 开始心跳检测
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      if (_isConnected) {
        _sendHeartbeat();
      }
    });
  }

  // 停止心跳检测
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  // 发送心跳消息
  void _sendHeartbeat() {
    try {
      if (_channel != null && _isConnected) {
        final heartbeat = jsonEncode({
          'type': 'ping',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
        _channel!.sink.add(heartbeat);
      }
    } catch (e) {
      print('发送心跳失败: $e');
    }
  }

  // 发送消息
  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      try {
        final messageStr = jsonEncode(message);
        _channel!.sink.add(messageStr);
        print('发送消息: $messageStr');
      } catch (e) {
        _errorController.add('发送消息失败: $e');
      }
    } else {
      _errorController.add('连接未建立，无法发送消息');
    }
  }

  // 订阅特定交易对
  void subscribeToSymbol(String symbol) {
    sendMessage({'type': 'subscribe', 'symbol': symbol});
  }

  // 取消订阅特定交易对
  void unsubscribeFromSymbol(String symbol) {
    sendMessage({'type': 'unsubscribe', 'symbol': symbol});
  }

  // 断开连接
  void disconnect() {
    print('断开WebSocket连接');
    _shouldReconnect = false;

    // 取消定时器
    _reconnectTimer?.cancel();
    _stopHeartbeat();

    // 关闭连接
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }

    if (_isConnected) {
      _isConnected = false;
      _connectionController.add(false);
    }
  }

  // 重置连接状态
  void reset() {
    disconnect();
    _reconnectAttempts = 0;
  }

  // 释放资源
  void dispose() {
    disconnect();

    // 关闭流控制器
    _connectionController.close();
    _dataController.close();
    _errorController.close();
  }

  // 获取连接统计信息
  Map<String, dynamic> getConnectionStats() {
    return {
      'isConnected': _isConnected,
      'reconnectAttempts': _reconnectAttempts,
      'maxReconnectAttempts': _maxReconnectAttempts,
      'shouldReconnect': _shouldReconnect,
    };
  }
}
