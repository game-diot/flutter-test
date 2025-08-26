// ==========================================
// lib/home_page/symbol_carousel/models/combined_chart_data.dart
// ==========================================

import '../../../../../../network/Get/models/home_page/home_data_section.dart';
import '../../../../../../socket/home_page_data_section/models.dart';

/// 合并后的图表数据模型
class CombinedChartData {
  final String symbolId;
  final String symbol;
  final String baseSymbol;
  final String alias;
  final String icon1;
  final double? currentPrice;
  final double? priceChangePercent;
  final double? priceChangeAmount;
  final bool hasRealTimeData;
  final List<double> miniKlinePriceList;
  final List<double> historicalPrices; // 实时价格历史

  CombinedChartData({
    required this.symbolId,
    required this.symbol,
    required this.baseSymbol,
    required this.alias,
    required this.icon1,
    this.currentPrice,
    this.priceChangePercent,
    this.priceChangeAmount,
    this.hasRealTimeData = false,
    this.miniKlinePriceList = const [],
    this.historicalPrices = const [],
  });

  /// 从SymbolItem创建
  factory CombinedChartData.fromSymbolItem(SymbolItem symbolItem) {
    return CombinedChartData(
      symbolId: symbolItem.symbolId,
      symbol: symbolItem.symbol,
      baseSymbol: symbolItem.baseSymbol,
      alias: symbolItem.alias,
      icon1: symbolItem.icon1,
      miniKlinePriceList: symbolItem.miniKlinePriceList,
      historicalPrices: List<double>.from(symbolItem.miniKlinePriceList),
    );
  }

  /// 更新实时数据
  CombinedChartData updateWithRealTimeData(ExchangeRateData exchangeRateData) {
    return CombinedChartData(
      symbolId: symbolId,
      symbol: symbol,
      baseSymbol: baseSymbol,
      alias: alias,
      icon1: icon1,
      currentPrice: exchangeRateData.price,
      priceChangePercent: exchangeRateData.percentChange,
      priceChangeAmount: exchangeRateData.priceChange,
      hasRealTimeData: true,
      miniKlinePriceList: miniKlinePriceList,
      historicalPrices: historicalPrices,
    );
  }

  /// 用于显示的名称
  String get displayName => alias.isNotEmpty ? alias : baseSymbol;

  /// 获取用于绘制图表的数据
  List<double> get chartData {
    if (hasRealTimeData && historicalPrices.isNotEmpty) {
      return historicalPrices;
    }
    return miniKlinePriceList.isNotEmpty ? miniKlinePriceList : [];
  }
}
