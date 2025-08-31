import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import '../../../../network/Get/models/home_page/home_data_section.dart';
import '../../../../socket/home_page_data_section/models.dart';
import '../../../../socket/home_page_data_section/services.dart';
import '../../../../localization/i18n/lang.dart';
import '../../../../../../providers/color/color.dart';

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
    if (hasRealTimeData && historicalPrices.isNotEmpty) {
      return historicalPrices;
    }
    return miniKlinePriceList.isNotEmpty ? miniKlinePriceList : [];
  }
}

/// 图表数据服务类，负责处理 WebSocket 连接
class ChartDataService {
  ExchangeRateWebSocketService? _webSocketService;
  Map<String, ExchangeRateData> _exchangeRateMap = {};

  Stream<Map<String, ExchangeRateData>>? get exchangeRateStream =>
      _webSocketService?.dataStream.map((response) {
        _exchangeRateMap.clear();
        for (final rate in response.data) {
          _exchangeRateMap[rate.symbol] = rate;
        }
        return Map.from(_exchangeRateMap);
      });

  void initWebSocket() {
    _webSocketService = ExchangeRateWebSocketService();
    _webSocketService?.connect();
  }

  void dispose() {
    _webSocketService?.disconnect();
  }
}

/// 绘制折线图
class LineChartEnhancedPainter extends CustomPainter {
  final List<double> data;
  final bool isLight;
  final Color trendColor;

  LineChartEnhancedPainter(this.data, this.isLight, this.trendColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    double minY = data.reduce((a, b) => a < b ? a : b);
    double maxY = data.reduce((a, b) => a > b ? a : b);
    double rangeY = maxY - minY == 0 ? 1 : maxY - minY;

    final stepX = data.length > 1 ? size.width / (data.length - 1) : 0;
    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      double x = (i * stepX).toDouble();
      double y = size.height - ((data[i] - minY) / rangeY) * size.height;
      points.add(Offset(x, y));
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }

    final shadowPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [trendColor.withOpacity(0.3), trendColor.withOpacity(0.05)],
    );

    final shadowPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(shadowPath, shadowPaint);

    final linePaint = Paint()
      ..color = trendColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    if (data.length <= 10) {
      final pointPaint = Paint()
        ..color = trendColor
        ..style = PaintingStyle.fill;
      for (final point in points) {
        canvas.drawCircle(point, 3, pointPaint);
      }
    }

    if (points.isNotEmpty) {
      final lastPointPaint = Paint()
        ..color = trendColor
        ..style = PaintingStyle.fill;
      final lastPointOutlinePaint = Paint()
        ..color = isLight ? Colors.white : Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(points.last, 4, lastPointPaint);
      canvas.drawCircle(points.last, 4, lastPointOutlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 图表卡片
class SymbolCardEnhanced extends StatelessWidget {
  final CombinedChartData item;
  final bool isLight;

  const SymbolCardEnhanced({
    Key? key,
    required this.item,
    required this.isLight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayPrice = item.hasRealTimeData && item.currentPrice != null
        ? item.currentPrice!
        : (item.miniKlinePriceList.isNotEmpty
              ? item.miniKlinePriceList.first
              : 0.0);

    final displayChange =
        item.hasRealTimeData && item.priceChangePercent != null
        ? item.priceChangePercent!
        : (item.miniKlinePriceList.length > 1
              ? item.miniKlinePriceList[1]
              : 0.0);

    final lineData = item.chartData.take(20).toList();

    final colorProvider = context.watch<ChangeColorProvider>();
    Color changeColor = colorProvider.mode == ChangeColorMode.redUpGreenDown
        ? displayChange >= 0
              ? Colors.red
              : Colors.green
        : displayChange >= 0
        ? Colors.green
        : Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: isLight ? Colors.white : Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isLight
                ? Colors.black.withOpacity(0.05)
                : Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                item.icon1,
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.currency_bitcoin,
                      size: 16,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLight ? Colors.black : Colors.white,
                  ),
                ),
              ),
              if (item.hasRealTimeData)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '${Lang.t('price')}: ¥${displayPrice.toStringAsFixed(2)}',
            style: TextStyle(color: isLight ? Colors.black : Colors.white),
          ),
          Text(
            '${Lang.t('price_change_percent')}: ${displayChange.toStringAsFixed(2)}%',
            style: TextStyle(color: changeColor),
          ),
          SizedBox(height: 8),
          Expanded(
            child: lineData.isNotEmpty
                ? CustomPaint(
                    painter: LineChartEnhancedPainter(
                      lineData,
                      isLight,
                      changeColor,
                    ),
                    size: Size(double.infinity, 60),
                  )
                : Center(
                    child: Text(
                      Lang.t('no_chart_data'),
                      style: TextStyle(
                        color: isLight ? Colors.black54 : Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// 主轮播组件
class SymbolCarousel extends StatefulWidget {
  final List<SymbolItem>? coinList;
  final bool? isLoading;

  const SymbolCarousel({Key? key, this.coinList, this.isLoading})
    : super(key: key);

  @override
  _SymbolCarouselState createState() => _SymbolCarouselState();
}

class _SymbolCarouselState extends State<SymbolCarousel> {
  late ChartDataService _chartDataService;
  Map<String, ExchangeRateData> _exchangeRateMap = {};
  List<CombinedChartData> _combinedData = [];

  @override
  void initState() {
    super.initState();
    _chartDataService = ChartDataService();
    _initWebSocket();
    _updateCombinedData();
  }

  void _initWebSocket() {
    _chartDataService.initWebSocket();
    _chartDataService.exchangeRateStream?.listen((exchangeRateMap) {
      if (!mounted) return;
      setState(() {
        _exchangeRateMap = exchangeRateMap;
        _updateCombinedData();
      });
    });
  }

  void _updateCombinedData() {
    if (widget.coinList == null) return;

    _combinedData = widget.coinList!.map((symbolItem) {
      final wsSymbol = symbolItem.symbol.replaceAll('_', '~');

      final prevData = _combinedData.firstWhere(
        (e) => e.symbol == symbolItem.symbol,
        orElse: () => CombinedChartData.fromSymbolItem(symbolItem),
      );

      final exchangeRate =
          _exchangeRateMap[wsSymbol] ?? _exchangeRateMap[symbolItem.symbol];

      if (exchangeRate != null) {
        final newData = CombinedChartData(
          symbolId: symbolItem.symbolId,
          symbol: symbolItem.symbol,
          baseSymbol: symbolItem.baseSymbol,
          alias: symbolItem.alias,
          icon1: symbolItem.icon1,
          currentPrice: exchangeRate.price,
          priceChangePercent: exchangeRate.percentChange,
          priceChangeAmount: exchangeRate.priceChange,
          hasRealTimeData: true,
          miniKlinePriceList: symbolItem.miniKlinePriceList,
          historicalPrices: _updateHistoricalPrices(
            prevData.historicalPrices,
            exchangeRate.price,
          ),
        );
        return newData;
      } else {
        return prevData;
      }
    }).toList();

    setState(() {});
  }

  List<double> _updateHistoricalPrices(
    List<double> previous,
    double? newPrice,
  ) {
    if (newPrice == null) return previous;
    final updated = List<double>.from(previous);
    updated.add(newPrice);
    if (updated.length > 50) updated.removeAt(0);
    return updated;
  }

  @override
  void didUpdateWidget(SymbolCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coinList != widget.coinList) {
      _updateCombinedData();
    }
  }

  @override
  void dispose() {
    _chartDataService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;

    if (widget.isLoading == true) {
      return Container(
        height: 150,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_combinedData.isEmpty) {
      return Container(
        height: 150,
        child: Center(
          child: Text(
            Lang.t('no_data'),
            style: TextStyle(color: isLight ? Colors.black54 : Colors.white54),
          ),
        ),
      );
    }

    return Container(
      height: 150,
      width: double.infinity,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: _combinedData.length,
        itemBuilder: (context, index) {
          final item = _combinedData[index];
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 8, right: 8),
            child: SymbolCardEnhanced(item: item, isLight: isLight),
          );
        },
      ),
    );
  }
}
