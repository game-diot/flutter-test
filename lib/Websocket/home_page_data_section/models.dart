// models/exchange_rate_model.dart
class ExchangeRateResponse {
  final String type;
  final List<ExchangeRateData> data;

  ExchangeRateResponse({
    required this.type,
    required this.data,
  });

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeRateResponse(
      type: json['type'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => ExchangeRateData.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class ExchangeRateData {
  final String symbol; // p - 交易对
  final double price; // a - 当前价格
  final double priceChange; // peA - 价格变动
  final double percentChange; // pe - 百分比变动
  final int timestamp; // t - 时间戳
  final int type; // ty - 类型 (1:外汇, 2:加密货币, 4:其他)
  final int status; // st - 状态
  final dynamic volume; // v - 交易量

  ExchangeRateData({
    required this.symbol,
    required this.price,
    required this.priceChange,
    required this.percentChange,
    required this.timestamp,
    required this.type,
    required this.status,
    this.volume,
  });

  factory ExchangeRateData.fromJson(Map<String, dynamic> json) {
    return ExchangeRateData(
      symbol: json['p'] ?? '',
      price: (json['a'] ?? 0.0).toDouble(),
      priceChange: (json['peA'] ?? 0.0).toDouble(),
      percentChange: (json['pe'] ?? 0.0).toDouble(),
      timestamp: json['t'] ?? 0,
      type: json['ty'] ?? 0,
      status: json['st'] ?? 0,
      volume: json['v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'p': symbol,
      'a': price,
      'peA': priceChange,
      'pe': percentChange,
      't': timestamp,
      'ty': type,
      'st': status,
      'v': volume,
    };
  }

  // 获取交易对名称 (去除下划线和波浪号)
  String get displayName {
    return symbol.replaceAll(RegExp(r'[_~]'), '/');
  }

  // 获取基础货币名称
  String get baseCurrency {
    return symbol.split(RegExp(r'[_~]')).first;
  }

  // 判断是否为加密货币
  bool get isCrypto => type == 2 || type == 4;

  // 判断是否为外汇
  bool get isForex => type == 1;

  // 复制并更新价格数据
  ExchangeRateData copyWith({
    double? price,
    double? priceChange,
    double? percentChange,
    int? timestamp,
  }) {
    return ExchangeRateData(
      symbol: symbol,
      price: price ?? this.price,
      priceChange: priceChange ?? this.priceChange,
      percentChange: percentChange ?? this.percentChange,
      timestamp: timestamp ?? this.timestamp,
      type: type,
      status: status,
      volume: volume,
    );
  }
}

// 历史数据点，用于绘制图表
class PriceDataPoint {
  final double price;
  final int timestamp;

  PriceDataPoint({
    required this.price,
    required this.timestamp,
  });

  factory PriceDataPoint.fromExchangeData(ExchangeRateData data) {
    return PriceDataPoint(
      price: data.price,
      timestamp: data.timestamp,
    );
  }
}
