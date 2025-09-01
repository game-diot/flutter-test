import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'models/combined_chart_data.dart';
import 'services/chart_data_service.dart';
import 'widgets/symbol_card_enhanced.dart';
import '../../../../network/Get/models/home_page/home_data_section.dart';
import '../../../../socket/home_page_data_section/exchange_rate_model.dart';

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
        return CombinedChartData(
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
    if (oldWidget.coinList != widget.coinList) _updateCombinedData();
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
      return SizedBox(
        height: 150,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_combinedData.isEmpty) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'No data',
            style: TextStyle(color: isLight ? Colors.black54 : Colors.white54),
          ),
        ),
      );
    }

    return SizedBox(
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
