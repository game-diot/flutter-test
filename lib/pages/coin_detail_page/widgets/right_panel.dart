import 'package:flutter/material.dart';
import '../models/model.dart';
import '../../../socket/home_page_data_section/exchange_depth_model.dart';

class RightPanel extends StatelessWidget {
  final CoinDetail coinDetail;
  final ExchangeDepth? exchangeDepth;

  const RightPanel({Key? key, required this.coinDetail, this.exchangeDepth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('🎨 [RightPanel] Building with exchangeDepth: ${exchangeDepth != null}');
    
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // 表头
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("价格", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("数量", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 1),
          
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // 如果没有深度数据，显示加载状态
    if (exchangeDepth == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              '等待盘口数据...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    // 安全地获取 asks 和 bids
    final asks = _getAsks();
    final bids = _getBids();
    
    print('🎨 [RightPanel] Asks: ${asks.length}, Bids: ${bids.length}');

    // 如果数据为空，显示空状态
    if (asks.isEmpty && bids.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '暂无盘口数据',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    // 计算最大成交量（用于背景比例）
    final maxVolume = _calculateMaxVolume(asks, bids);

    return SingleChildScrollView(
      child: Column(
        children: [
          // 卖单区域
          if (asks.isNotEmpty) ...[
            ...asks.map((item) => _buildRow(item, maxVolume, isSell: true)),
            const Divider(height: 1, color: Colors.grey),
          ],
          
          // 买单区域
          if (bids.isNotEmpty) ...[
            ...bids.map((item) => _buildRow(item, maxVolume, isSell: false)),
          ],
          
          // 如果只有一种数据，显示提示
          if (asks.isEmpty && bids.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('暂无卖单', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          if (bids.isEmpty && asks.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('暂无买单', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  /// 安全地获取卖单列表
  List<OrderBookItem> _getAsks() {
    try {
      if (exchangeDepth?.asks == null) return [];
      return exchangeDepth!.asks.reversed.toList();
    } catch (e) {
      print('❌ [RightPanel] Error getting asks: $e');
      return [];
    }
  }

  /// 安全地获取买单列表
  List<OrderBookItem> _getBids() {
    try {
      if (exchangeDepth?.bids == null) return [];
      return exchangeDepth!.bids.toList();
    } catch (e) {
      print('❌ [RightPanel] Error getting bids: $e');
      return [];
    }
  }

  /// 计算最大成交量
  double _calculateMaxVolume(List<OrderBookItem> asks, List<OrderBookItem> bids) {
    try {
      double maxVolume = 0;
      
      if (asks.isNotEmpty) {
        final askMax = asks.map((e) => e.volume).reduce((a, b) => a > b ? a : b);
        maxVolume = askMax > maxVolume ? askMax : maxVolume;
      }
      
      if (bids.isNotEmpty) {
        final bidMax = bids.map((e) => e.volume).reduce((a, b) => a > b ? a : b);
        maxVolume = bidMax > maxVolume ? bidMax : maxVolume;
      }
      
      return maxVolume;
    } catch (e) {
      print('❌ [RightPanel] Error calculating max volume: $e');
      return 0;
    }
  }

  Widget _buildRow(
    OrderBookItem item,
    double maxVolume, {
    required bool isSell,
  }) {
    try {
      final double widthFactor = maxVolume > 0 ? (item.volume / maxVolume) : 0.0;
      final bgColor = isSell
          ? Colors.red.withOpacity(0.2)
          : Colors.green.withOpacity(0.2);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Stack(
          children: [
            // 背景条
            if (widthFactor > 0)
              FractionallySizedBox(
                widthFactor: widthFactor.clamp(0.0, 1.0), // 确保在 0-1 范围内
                alignment: isSell ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(height: 28, color: bgColor),
              ),
            
            // 文字内容
            Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.price.toStringAsFixed(2),
                    style: TextStyle(
                      color: isSell ? Colors.red : Colors.green,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    item.volume.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print('❌ [RightPanel] Error building row: $e');
      // 出错时返回空容器，避免崩溃
      return const SizedBox(height: 28);
    }
  }
}