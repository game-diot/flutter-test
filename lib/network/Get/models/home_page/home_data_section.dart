class SymbolItem {
  
  final String symbolId;
  final String alias;
  final String symbol;
  final String baseSymbol;
  final String exchangeSymbol;
  final String icon1;
  final String icon2;
  final double volume24h;
  final List<double> miniKlinePriceList;
  final double commission;
  final int priceAccuracy;
  final int transactionAccuracy;

  SymbolItem({
    required this.symbolId,
    required this.alias,
    required this.symbol,
    required this.baseSymbol,
    required this.exchangeSymbol,
    required this.icon1,
    required this.icon2,
    required this.volume24h,
    required this.miniKlinePriceList,
    required this.commission,
    required this.priceAccuracy,
    required this.transactionAccuracy,
  });

  factory SymbolItem.fromJson(Map<String, dynamic> json) {
    return SymbolItem(
      symbolId: json['symbolId'] ?? '',
      alias: json['alias'] ?? '',
      symbol: json['symbol'] ?? '',
      baseSymbol: json['baseSymbol'] ?? '',
      exchangeSymbol: json['exchangeSymbol'] ?? '',
      icon1: json['icon1'] ?? '',
      icon2: json['icon2'] ?? '',
      volume24h: (json['volume24h'] ?? 0).toDouble(),
      miniKlinePriceList: (json['miniKlinePriceList'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      commission: (json['commission'] ?? 0).toDouble(),
      priceAccuracy: json['priceAccuracy'] ?? 0,
      transactionAccuracy: json['transactionAccuracy'] ?? 0,
    );
  }
}
