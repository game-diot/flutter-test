import '../../../../../network/Get/models/home_page/home_data_section.dart';
import '../../../../../socket/home_page_data_section/exchange_rate_model.dart';

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
  final List<double> historicalPrices;

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

  String get displayName => alias.isNotEmpty ? alias : baseSymbol;

  List<double> get chartData {
    if (hasRealTimeData && historicalPrices.isNotEmpty) return historicalPrices;
    return miniKlinePriceList.isNotEmpty ? miniKlinePriceList : [];
  }
}
