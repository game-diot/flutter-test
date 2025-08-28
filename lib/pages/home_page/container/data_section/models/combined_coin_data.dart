
import '../../../../../network/Get/models/home_page/home_data_section.dart';
import '../../../../../socket/home_page_data_section/models.dart';

/// 合并后的显示数据模型
class CombinedCoinData {
  final String symbolId;
  final String symbol;
  final String baseSymbol;
  final String alias;
  final String icon1;
  final double? currentPrice;
  final double? priceChangePercent;
  final double? priceChangeAmount;
  final bool hasRealTimeData;

  CombinedCoinData({
    required this.symbolId,
    required this.symbol,
    required this.baseSymbol,
    required this.alias,
    required this.icon1,
    this.currentPrice,
    this.priceChangePercent,
    this.priceChangeAmount,
    this.hasRealTimeData = false,
  });

  /// 从SymbolItem创建
  factory CombinedCoinData.fromSymbolItem(SymbolItem symbolItem) {
    return CombinedCoinData(
      symbolId: symbolItem.symbolId,
      symbol: symbolItem.symbol,
      baseSymbol: symbolItem.baseSymbol,
      alias: symbolItem.alias,
      icon1: symbolItem.icon1,
    );
  }

  /// 更新实时数据
  CombinedCoinData updateWithRealTimeData(ExchangeRateData exchangeRateData) {
    return CombinedCoinData(
      symbolId: symbolId,
      symbol: symbol,
      baseSymbol: baseSymbol,
      alias: alias,
      icon1: icon1,
      currentPrice: exchangeRateData.price,
      priceChangePercent: exchangeRateData.percentChange,
      priceChangeAmount: exchangeRateData.priceChange,
      hasRealTimeData: true,
    );
  }

  /// 用于显示的名称
  String get displayName => alias.isNotEmpty ? alias : baseSymbol;
}