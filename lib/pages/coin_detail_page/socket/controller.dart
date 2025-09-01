// controllers/depth_data_controller.dart
import 'package:flutter/material.dart';
import '../models/model.dart'; // CoinDetail 模型
import '../../../../../socket/home_page_data_section/exchange_depth_model.dart';
import '../../../../../socket/home_page_data_section/services.dart';
import 'service.dart';

class DepthDataController extends ChangeNotifier {
  final DepthDataService _depthService = DepthDataService();

  // 当前交易对深度数据
  ExchangeDepth? _currentDepth;

  ExchangeDepth? get currentDepth => _currentDepth;

  // 初始化 WebSocket 并监听深度数据
  void init(String symbol) {
    _depthService.initWebSocket();

    _depthService.exchangeDepthStream?.listen((depthMap) {
      final normalizedSymbol = symbol.replaceAll('_', '~');
      final depth = depthMap[normalizedSymbol] ?? depthMap[symbol];

      if (depth != null) {
        _currentDepth = depth;
        notifyListeners(); // 通知 UI 更新
      }
    });
  }

  // 可选：订阅指定交易对
  void subscribe(String symbol) {
    _depthService.subscribeSymbol(symbol);
  }

  // 可选：取消订阅
  void unsubscribe(String symbol) {
    _depthService.unsubscribeSymbol(symbol);
  }

  // 获取当前缓存的深度
  ExchangeDepth? getDepth(String symbol) {
    return _depthService.getDepthBySymbol(symbol);
  }

  // 断开 WebSocket
  void dispose() {
    _depthService.dispose();
    super.dispose();
  }
}
