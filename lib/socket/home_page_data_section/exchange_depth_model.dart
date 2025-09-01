class ExchangeDepth {
  final String symbol;
  final List<OrderBookItem> bids;
  final List<OrderBookItem> asks;
  final int timestamp;

  ExchangeDepth({
    required this.symbol,
    required this.bids,
    required this.asks,
    required this.timestamp,
  });

  factory ExchangeDepth.fromJson(Map<String, dynamic> json) {
    List<OrderBookItem> parseOrders(List<dynamic>? list) {
      if (list == null) return [];
      return list.map((item) {
        if (item is List && item.length >= 2) {
          return OrderBookItem(price: (item[0] ?? 0.0).toDouble(), volume: (item[1] ?? 0.0).toDouble());
        }
        return OrderBookItem(price: 0.0, volume: 0.0);
      }).toList();
    }

    return ExchangeDepth(
      symbol: json['symbol'] ?? '',
      bids: parseOrders(json['bids'] as List<dynamic>?),
      asks: parseOrders(json['asks'] as List<dynamic>?),
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    List<List<double>> toList(List<OrderBookItem> orders) =>
        orders.map((e) => [e.price, e.volume]).toList();

    return {
      'symbol': symbol,
      'bids': toList(bids),
      'asks': toList(asks),
      'timestamp': timestamp,
    };
  }
}

class OrderBookItem {
  final double price;
  final double volume;

  OrderBookItem({required this.price, required this.volume});
}
