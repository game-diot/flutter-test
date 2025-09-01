import 'package:flutter/material.dart';
import '../../../socket/home_page_data_section/services.dart';
import '../../../../socket/home_page_data_section/exchange_depth_model.dart';
import 'dart:async';

class DepthDataController extends ChangeNotifier {
  final ExchangeWebSocketService _webSocketService;
  StreamSubscription? _depthSubscription;
  ExchangeDepth? _currentDepth;
  String? _currentSymbol;

  DepthDataController(this._webSocketService);

  ExchangeDepth? get currentDepth => _currentDepth;
  bool get hasData => _currentDepth != null;

  /// 初始化并订阅指定交易对
  void init(String symbol) {
    print('🔧 [Depth Controller] Initializing for symbol: $symbol');

    // 如果已经订阅了其他交易对，先取消订阅
    if (_currentSymbol != null && _currentSymbol != symbol) {
      _webSocketService.unsubscribeFromDepth(_currentSymbol!);
    }

    _currentSymbol = symbol;

    // 订阅盘口数据流
    _depthSubscription?.cancel();
    _depthSubscription = _webSocketService.depthStream.listen((depthList) {
      print(
        '🔧 [Depth Controller] Received depth list: ${depthList.length} items',
      );

      // 查找当前交易对的数据
      final depth = depthList.cast<ExchangeDepth?>().firstWhere(
        (d) => d?.symbol == symbol,
      );

      if (depth != null) {
        print('✅ [Depth Controller] Found depth data for ${depth.symbol}');
        _currentDepth = depth;
        notifyListeners();
      } else {
        print('❌ [Depth Controller] No depth data found for $symbol');
      }
    });

    // 确保 WebSocket 连接后再订阅
    if (_webSocketService.isConnected) {
      _subscribeToCurrentSymbol();
    } else {
      // 监听连接状态，连接成功后订阅
      _webSocketService.connectionStream.listen((isConnected) {
        if (isConnected && _currentSymbol != null) {
          Future.delayed(Duration(milliseconds: 500), () {
            _subscribeToCurrentSymbol();
          });
        }
      });
    }
  }

  void _subscribeToCurrentSymbol() {
    if (_currentSymbol != null) {
      _webSocketService.subscribeToDepth(_currentSymbol!);
    }
  }

  /// 切换到新的交易对
  void switchSymbol(String newSymbol) {
    if (_currentSymbol != newSymbol) {
      init(newSymbol);
    }
  }

  @override
  void dispose() {
    if (_currentSymbol != null) {
      _webSocketService.unsubscribeFromDepth(_currentSymbol!);
    }
    _depthSubscription?.cancel();
    super.dispose();
  }
}
