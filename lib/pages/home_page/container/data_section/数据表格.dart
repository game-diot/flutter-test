import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import '../../../../providers/exchange/exchange.dart';
import '../../../../providers/color/color.dart';
import '../../../../network/Get/models/home_page/home_data_section.dart';
import '../../../../socket/home_page_data_section/models.dart';
import '../../../../socket/home_page_data_section/services.dart';
import '../../../../localization/i18n/lang.dart';
import '../../../coin_detail_page/coin_detail_page.dart';
import 'models/combined_coin_data.dart';

/// =====================
/// WebSocket 服务
/// =====================
class DataSectionService {
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

  void sortCombinedData(
    List<CombinedCoinData> data,
    String key,
    bool ascending,
  ) {
    data.sort((a, b) {
      int result;
      switch (key) {
        case '名称':
          result = a.displayName.compareTo(b.displayName);
          break;
        case '价格':
          if (a.currentPrice == null && b.currentPrice == null) return 0;
          if (a.currentPrice == null) return 1;
          if (b.currentPrice == null) return -1;
          result = a.currentPrice!.compareTo(b.currentPrice!);
          break;
        case '涨幅比':
          if (a.priceChangePercent == null && b.priceChangePercent == null)
            return 0;
          if (a.priceChangePercent == null) return 1;
          if (b.priceChangePercent == null) return -1;
          result = a.priceChangePercent!.compareTo(b.priceChangePercent!);
          break;
        default:
          return 0;
      }
      return ascending ? result : -result;
    });
  }
}

/// =====================
/// DataSection 主组件
/// =====================
class DataSection extends StatefulWidget {
  final List<SymbolItem>? coinList;
  final bool? isLoading;

  const DataSection({Key? key, this.coinList, this.isLoading})
    : super(key: key);

  @override
  _DataSectionState createState() => _DataSectionState();
}

class _DataSectionState extends State<DataSection> {
  int _selectedIndex = 0;
  late DataSectionService _dataSectionService;
  Map<String, ExchangeRateData> _exchangeRateMap = {};
  List<CombinedCoinData> _combinedData = [];

  Map<String, bool> _sortAscCoin = {'名称': true, '价格': true, '涨幅比': true};
  String _currentSortKey = '名称';
  bool _currentSortAsc = true;

  @override
  void initState() {
    super.initState();
    _dataSectionService = DataSectionService();
    _initWebSocket();
    _updateCombinedData();
  }

  void _initWebSocket() {
    _dataSectionService.initWebSocket();
    _dataSectionService.exchangeRateStream?.listen((exchangeRateMap) {
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
        orElse: () => CombinedCoinData.fromSymbolItem(symbolItem),
      );

      final exchangeRate =
          _exchangeRateMap[wsSymbol] ?? _exchangeRateMap[symbolItem.symbol];

      if (exchangeRate != null) {
        return CombinedCoinData(
          symbolId: symbolItem.symbolId,
          symbol: symbolItem.symbol,
          baseSymbol: symbolItem.baseSymbol,
          alias: symbolItem.alias,
          icon1: symbolItem.icon1,
          currentPrice: exchangeRate.price,
          priceChangePercent: exchangeRate.percentChange,
          priceChangeAmount: exchangeRate.priceChange,
          hasRealTimeData: true,
        );
      } else {
        return prevData;
      }
    }).toList();

    if (_currentSortKey.isNotEmpty) {
      _dataSectionService.sortCombinedData(
        _combinedData,
        _currentSortKey,
        _currentSortAsc,
      );
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(DataSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coinList != widget.coinList) _updateCombinedData();
  }

  @override
  void dispose() {
    _dataSectionService.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSortCombinedData(String key) {
    setState(() {
      bool ascending = _sortAscCoin[key]!;
      _dataSectionService.sortCombinedData(_combinedData, key, ascending);
      _sortAscCoin[key] = !ascending;
      _currentSortKey = key;
      _currentSortAsc = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    final textColor = isLight ? Colors.black : Colors.white;
    final subTextColor = isLight ? Colors.grey[700] : Colors.grey[400];

    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isLight ? Colors.white : const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DataSectionHeader(
            selectedIndex: _selectedIndex,
            onTabChanged: _onTabChanged,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<ExchangeRateProvider>(
              builder: (context, provider, _) {
                return _buildTableContent(provider, textColor, subTextColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent(
    ExchangeRateProvider provider,
    Color textColor,
    Color? subTextColor,
  ) {
    if (widget.coinList != null && _selectedIndex == 0) {
      final translatedSortKeys = {
        Lang.t('name'): _sortAscCoin['名称']!,
        Lang.t('price'): _sortAscCoin['价格']!,
        Lang.t('price_change_percent'): _sortAscCoin['涨幅比']!,
      };

      return _CombinedTable(
        data: _combinedData,
        isLoading: widget.isLoading == true,
        sortAscending: translatedSortKeys,
        onSort: (key) {
          final originalKeyMap = {
            Lang.t('name'): '名称',
            Lang.t('price'): '价格',
            Lang.t('price_change_percent'): '涨幅比',
          };
          _onSortCombinedData(originalKeyMap[key]!);
        },
        textColor: textColor,
        subTextColor: subTextColor,
        onRowTap: (coin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SocketBindPage(coin: coin)),
          );
        },
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Lang.t('no_data'),
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            Lang.t('switch_other_tab'),
            style: TextStyle(color: subTextColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// =====================
/// 顶部切换栏组件
/// =====================
class _DataSectionHeader extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const _DataSectionHeader({
    Key? key,
    required this.selectedIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    final textColor = isLight ? Colors.black : Colors.white;
    final dividerColor = isLight
        ? Colors.grey.withOpacity(0.3)
        : Colors.grey[700];

    final labels = [
      Lang.t('main_coins'),
      Lang.t('hot_list'),
      Lang.t('gainers_list'),
      Lang.t('exchanges'),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Row(
            children: List.generate(labels.length, (index) {
              final isSelected = selectedIndex == index;
              final labelColor = isSelected
                  ? textColor
                  : const Color.fromRGBO(134, 144, 156, 1);

              return Padding(
                padding: EdgeInsets.only(
                  right: index == labels.length - 1 ? 0 : 16,
                ),
                child: GestureDetector(
                  onTap: () => onTabChanged(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          left: 6,
                          right: 6,
                        ),
                        child: Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: labelColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          height: 4,
                          width: 15,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(237, 176, 35, 1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        Container(height: 1, color: dividerColor),
      ],
    );
  }
}

/// =====================
/// 合并数据表格组件
/// =====================
class _CombinedTable extends StatelessWidget {
  final List<CombinedCoinData> data;
  final bool isLoading;
  final Map<String, bool> sortAscending;
  final Function(String) onSort;
  final Color textColor;
  final Color? subTextColor;
  final Function(CombinedCoinData)? onRowTap;

  const _CombinedTable({
    Key? key,
    required this.data,
    required this.isLoading,
    required this.sortAscending,
    required this.onSort,
    required this.textColor,
    required this.subTextColor,
    this.onRowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (data.isEmpty)
      return Center(
        child: Text(Lang.t('no_data'), style: TextStyle(color: textColor)),
      );

    return Column(children: [_buildHeader(), _buildContent()]);
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          _buildSortableHeader(
            Lang.t('name'),
            flex: 2,
            alignment: MainAxisAlignment.start,
          ),
          _buildSortableHeader(
            Lang.t('price'),
            flex: 1,
            alignment: MainAxisAlignment.end,
          ),
          _buildSortableHeader(
            Lang.t('price_change_percent'),
            flex: 1,
            alignment: MainAxisAlignment.end,
          ),
        ],
      ),
    );
  }

  Widget _buildSortableHeader(
    String title, {
    int flex = 1,
    MainAxisAlignment? alignment,
  }) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => onSort(title),
        child: Row(
          mainAxisAlignment: alignment ?? MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: const Color.fromRGBO(134, 144, 156, 1),
              ),
            ),
            Icon(
              sortAscending[title] == true
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 16,
              color: const Color.fromRGBO(134, 144, 156, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Transform.translate(
        offset: const Offset(-8, 0),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => _buildTableRow(data[index], context),
        ),
      ),
    );
  }

  Widget _buildTableRow(CombinedCoinData item, BuildContext context) {
    return InkWell(
      onTap: () => onRowTap?.call(item),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          children: [
            Image.network(
              item.icon1,
              width: 28,
              height: 28,
              errorBuilder: (_, __, ___) => Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.currency_bitcoin,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayName,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (item.symbol != item.baseSymbol)
                    Text(
                      item.symbol,
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: item.hasRealTimeData && item.currentPrice != null
                    ? Text(
                        '¥${item.currentPrice!.toStringAsFixed(2)}',
                        style: TextStyle(color: textColor),
                      )
                    : Text(
                        '--',
                        style: TextStyle(color: textColor.withOpacity(0.5)),
                      ),
              ),
            ),
            Expanded(
              flex: 1,
              child: item.hasRealTimeData && item.priceChangePercent != null
                  ? Consumer<ChangeColorProvider>(
                      builder: (context, colorProvider, _) {
                        final mode = colorProvider.mode;
                        final isUp = item.priceChangePercent! >= 0;
                        final valueColor =
                            mode == ChangeColorMode.greenUpRedDown
                            ? (isUp ? Colors.green : Colors.red)
                            : (isUp ? Colors.red : Colors.green);
                        return Text(
                          '${item.priceChangePercent!.toStringAsFixed(2)}%',
                          textAlign: TextAlign.right,
                          style: TextStyle(color: valueColor),
                        );
                      },
                    )
                  : Text(
                      '--',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: textColor.withOpacity(0.5)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
