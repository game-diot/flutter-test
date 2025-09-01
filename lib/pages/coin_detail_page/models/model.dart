import 'dart:convert';

class CommissionLevel {
  final int level;
  final double makerFee;
  final double takerFee;

  CommissionLevel({
    required this.level,
    required this.makerFee,
    required this.takerFee,
  });

  factory CommissionLevel.fromJson(Map<String, dynamic> json) {
    return CommissionLevel(
      level: json['level'] ?? 0,
      makerFee: (json['makerFee'] ?? 0).toDouble(),
      takerFee: (json['takerFee'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level,
        'makerFee': makerFee,
        'takerFee': takerFee,
      };
}

class CoinDetail {
  final String symbol; // 交易对，例如 BTC~USDT
  final String alias; // 例如 BTCUSDT
  final String baseAlias; // 基础货币，例如 BTC
  final String coinAlias; // 计价货币，例如 USDT
  final String? coinName;
  final String? icon1;
  final String? icon2;
  final double volume24h;
  final int priceAccuracy;
  final int transactionAccuracy;
  final int status; // 状态
  final String coinId;
  final String symbolName;
  final List<CommissionLevel> commissionConfig;

  CoinDetail({
    required this.symbol,
    required this.alias,
    required this.baseAlias,
    required this.coinAlias,
    this.coinName,
    this.icon1,
    this.icon2,
    required this.volume24h,
    required this.priceAccuracy,
    required this.transactionAccuracy,
    required this.status,
    required this.coinId,
    required this.symbolName,
    required this.commissionConfig,
  });

  /// 常见计价币集合
  static const List<String> quoteCurrencies = ["USDT", "USDC", "USD", "BTC", "ETH"];

  /// 工厂方法：从 JSON 解析
  factory CoinDetail.fromJson(Map<String, dynamic> json) {
    final alias = json['alias'] ?? '';

    // 尝试解析 commissionConfig
    List<CommissionLevel> commissionLevels = [];
    final rawConfig = json['commissionConfig'];
    if (rawConfig is List) {
      commissionLevels =
          rawConfig.map((e) => CommissionLevel.fromJson(Map<String, dynamic>.from(e))).toList();
    } else if (rawConfig is String && rawConfig.isNotEmpty) {
      try {
        final List<dynamic> configList = jsonDecode(rawConfig);
        commissionLevels =
            configList.map((e) => CommissionLevel.fromJson(Map<String, dynamic>.from(e))).toList();
      } catch (e) {
        print("⚠️ 解析字符串 commissionConfig 失败: $e");
      }
    }

    final coinCurrency = _extractCoinCurrency(alias);
    final baseCurrency = _extractBaseCurrency(alias, coinCurrency);

    return CoinDetail(
      symbol: json['symbol'] ?? alias,
      alias: alias,
      baseAlias: baseCurrency,
      coinAlias: coinCurrency,
      coinName: json['coinName'],
      icon1: json['icon1'],
      icon2: json['icon2'],
      volume24h: (json['volume24h'] ?? 0).toDouble(),
      priceAccuracy: json['priceAccuracy'] ?? 2,
      transactionAccuracy: json['transactionAccuracy'] ?? 2,
      status: json['status'] ?? 0,
      coinId: json['coinId'] ?? 0,
      symbolName: json['symbolName'] ?? alias,
      commissionConfig: commissionLevels,
    );
  }

  /// 解析计价币（右边的币种）
  static String _extractCoinCurrency(String alias) {
    for (final quote in quoteCurrencies) {
      if (alias.endsWith(quote)) return quote;
    }
    return "USDT"; // 默认值
  }

  /// 解析基础币（左边的币种）
  static String _extractBaseCurrency(String alias, String coinCurrency) {
    if (alias.isNotEmpty && coinCurrency.isNotEmpty) {
      return alias.replaceAll(coinCurrency, "");
    }
    return alias;
  }

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'alias': alias,
        'baseAlias': baseAlias,
        'coinAlias': coinAlias,
        'coinName': coinName,
        'icon1': icon1,
        'icon2': icon2,
        'volume24h': volume24h,
        'priceAccuracy': priceAccuracy,
        'transactionAccuracy': transactionAccuracy,
        'status': status,
        'coinId': coinId,
        'symbolName': symbolName,
        'commissionConfig': commissionConfig.map((e) => e.toJson()).toList(),
      };
}
