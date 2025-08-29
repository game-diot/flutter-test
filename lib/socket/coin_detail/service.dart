// lib/socket/coin_detail/service.dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'models.dart';

/// 完整打印 + 模型解析的 WebSocket 服务
class FullPrintSocketService {
  final String wsUrl =
      "wss://us12-h5.yanshi.lol/app-websocket?Authorization=c384824463dc472187edc2d35caafa3d&version=v1";

  late WebSocketChannel _channel;
  final StreamController<NewAccountStatistics> _statsController =
      StreamController.broadcast();

  Stream<NewAccountStatistics> get statsStream => _statsController.stream;

  /// 连接 WebSocket
  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _channel.stream.listen(
      (message) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(message);

          final type = jsonData['type'] ?? 'UNKNOWN';
          final data = jsonData['data'];

          // 打印所有原始消息
          print("收到消息类型: $type");
          print("原始消息内容: $data");

          // 只处理 NEW_ACCOUNT_STATISTICS 类型
          if (type == 'NEW_ACCOUNT_STATISTICS' && data != null) {
            final stats = NewAccountStatistics.fromJson(data);
            _statsController.add(stats);

            print("监听到 NEW_ACCOUNT_STATISTICS 数据更新");
            _printStats(stats); // 打印解析后的详细信息
          }
        } catch (e) {
          print("解析失败: $e");
        }
      },
      onError: (error) => print("Socket错误: $error"),
      onDone: () => print("Socket已关闭"),
    );
  }

  /// 关闭连接
  void disconnect() {
    _channel.sink.close();
  }

  /// 销毁 StreamController
  void dispose() {
    _statsController.close();
    disconnect();
  }

  /// 打印解析后的统计信息
  void _printStats(NewAccountStatistics stats) {
    print("=== Overview ===");
    print("总资产 ta: ${stats.overview.ta}");
    print("总成交量 tpv: ${stats.overview.tpv}");
    print("总浮动盈亏 tfpl: ${stats.overview.tfpl}");
    print("累计资产 taa: ${stats.overview.taa}");
    print("累计盈亏 tfa: ${stats.overview.tfa}");
    print("钱包 tw: ${stats.overview.tw}");
    print("盈亏 tr: ${stats.overview.tr}");
    print("热钱包 hotpal: ${stats.overview.hotpal}");

    print("--- Contract ---");
    print("合约总资产 ta: ${stats.contract.ta}");
    print("合约成交量 tpv: ${stats.contract.tpv}");
    print("合约累计资产 taa: ${stats.contract.taa}");
    print("合约累计盈亏 tfa: ${stats.contract.tfa}");
    print("合约浮动盈亏 tfpl: ${stats.contract.tfpl}");
    print("合约已平盈亏 tdpl: ${stats.contract.tdpl}");
    print("合约热钱包 hotpal: ${stats.contract.hotpal}");
    for (var pl in stats.contract.plList) {
      print(
          "PL Item: ${pl.subscribeSymbol}, plAmount: ${pl.plAmount}, plRatio: ${pl.plRatio}, lever: ${pl.lever}, endPrice: ${pl.endPrice}, direction: ${pl.direction}");
    }

    print("--- Coin ---");
    print("总资产 ta: ${stats.coin.ta}");
    print("累计资产 taa: ${stats.coin.taa}");
    print("累计盈亏 tfa: ${stats.coin.tfa}");
    for (var w in stats.coin.walletList) {
      print("Wallet: ${w.name}, ab: ${w.ab}");
    }
  }
}
