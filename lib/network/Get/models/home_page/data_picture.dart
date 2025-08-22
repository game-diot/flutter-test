class SymbolItem {
  final String id;
  final String symbol;
  final String? company;
  final String coinAlias;
  final String coinName;
  final double commission;
  final int maxNum;
  final String alias;
  final int commissionType;
  final double lastPrice;
  final List<TimePrice> timePriceList;

  SymbolItem({
    required this.id,
    required this.symbol,
    this.company,
    required this.coinAlias,
    required this.coinName,
    required this.commission,
    required this.maxNum,
    required this.alias,
    required this.commissionType,
    required this.lastPrice,
    required this.timePriceList,
  });

  factory SymbolItem.fromJson(Map<String, dynamic> json) {
    return SymbolItem(
      id: json['id'],
      symbol: json['symbol'],
      company: json['company'],
      coinAlias: json['coinAlias'],
      coinName: json['coinName'],
      commission: (json['commission'] ?? 0).toDouble(),
      maxNum: json['maxNum'] ?? 0,
      alias: json['alias'],
      commissionType: json['commissionType'] ?? 0,
      lastPrice: (json['lastPrice'] ?? 0).toDouble(),
      timePriceList: (json['timePriceList'] as List<dynamic>?)
              ?.map((e) => TimePrice.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TimePrice {
  final int timestamp;
  final double price;

  TimePrice({
    required this.timestamp,
    required this.price,
  });

  factory TimePrice.fromJson(Map<String, dynamic> json) {
    return TimePrice(
      timestamp: json['timestamp'],
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

class SymbolResponse {
  final List<SymbolItem> list;
  final int total;

  SymbolResponse({required this.list, required this.total});

  factory SymbolResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return SymbolResponse(
      list: (data['list'] as List<dynamic>?)
              ?.map((e) => SymbolItem.fromJson(e))
              .toList() ??
          [],
      total: data['total'] ?? 0,
    );
  }
}