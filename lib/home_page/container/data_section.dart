// lib/home_page/data_section.dart
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/color/color.dart';
import '../../providers/exchange/exchange.dart';
import '../../network/Get/models/home_page/home_data_section.dart';
import 'dart:convert';
import 'dart:io';
import '../../Websocket/home_page_data_section/models.dart';
import '../../Websocket/home_page_data_section/services.dart';

// 合并后的显示数据模型
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

  // 从SymbolItem创建
  factory CombinedCoinData.fromSymbolItem(SymbolItem symbolItem) {
    return CombinedCoinData(
      symbolId: symbolItem.symbolId,
      symbol: symbolItem.symbol,
      baseSymbol: symbolItem.baseSymbol,
      alias: symbolItem.alias,
      icon1: symbolItem.icon1,
    );
  }

  // 更新实时数据
  CombinedCoinData updateWithRealTimeData(ExchangeRateData ExchangeRateData) {
    return CombinedCoinData(
      symbolId: symbolId,
      symbol: symbol,
      baseSymbol: baseSymbol,
      alias: alias,
      icon1: icon1,
      currentPrice: ExchangeRateData.price,
      priceChangePercent: ExchangeRateData.percentChange,
      priceChangeAmount: ExchangeRateData.priceChange,
      hasRealTimeData: true,
    );
  }

  // 用于显示的名称
  String get displayName => alias.isNotEmpty ? alias : baseSymbol;
}



class DataSection extends StatefulWidget {
  final List<SymbolItem>? coinList; // 添加可选的coinList参数
  final bool? isLoading; // 添加可选的加载状态
  
  const DataSection({
    Key? key, 
    this.coinList, 
    this.isLoading,
  }) : super(key: key);

  @override
  _DataSectionState createState() => _DataSectionState();
}

class _DataSectionState extends State<DataSection> {
  int _selectedIndex = 0;
  ExchangeRateWebSocketService? _webSocketService;
  Map<String, ExchangeRateData> _exchangeRateMap = {};
  List<CombinedCoinData> _combinedData = [];

  Map<String, bool> _sortAscCoin = {'名称': true, '价格': true, '涨幅比': true};
  Map<String, bool> _sortAscExchange = {'名称': true, '交易额': true, '评分': true};

  @override
  void initState() {
    super.initState();
    _initWebSocket();
    _updateCombinedData();
  }

  void _initWebSocket() {
  _webSocketService = ExchangeRateWebSocketService();
  _webSocketService?.connect();

  // 直接监听 dataStream
  _webSocketService?.dataStream.listen((response) {
    if (!mounted) return;

    setState(() {
      // 更新汇率映射
      _exchangeRateMap.clear();
      for (final rate in response.data) {
        _exchangeRateMap[rate.symbol] = rate;
      }

      // 重新合并数据
      _updateCombinedData();
    });
  });
}


  void _updateCombinedData() {
    if (widget.coinList != null) {
      _combinedData = widget.coinList!.map((symbolItem) {
        final baseData = CombinedCoinData.fromSymbolItem(symbolItem);
        
        // 查找对应的实时数据
        final exchangeRate = _exchangeRateMap[symbolItem.symbol];
        if (exchangeRate != null) {
          return baseData.updateWithRealTimeData(exchangeRate);
        }
        
        return baseData;
      }).toList();
    }
  }

  @override
  void didUpdateWidget(DataSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coinList != widget.coinList) {
      _updateCombinedData();
    }
  }

  @override
  void dispose() {
    _webSocketService?.disconnect();
    super.dispose();
  }

  void _onTextClicked(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSortCombinedData(String key) {
    setState(() {
      bool ascending = _sortAscCoin[key]!;
      _combinedData.sort((a, b) {
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
            if (a.priceChangePercent == null && b.priceChangePercent == null) return 0;
            if (a.priceChangePercent == null) return 1;
            if (b.priceChangePercent == null) return -1;
            result = a.priceChangePercent!.compareTo(b.priceChangePercent!);
            break;
          default:
            return 0;
        }
        return ascending ? result : -result;
      });
      _sortAscCoin[key] = !ascending;
    });
  }

  void _onSortCoin(String key, ExchangeRateProvider provider) {
    String sortBy = key == '名称'
        ? 'symbol'
        : key == '价格'
            ? 'price'
            : 'change';
    provider.setSorting(sortBy, ascending: _sortAscCoin[key]!);
    _sortAscCoin[key] = !_sortAscCoin[key]!;
  }

  void _onSortExchange(String key, ExchangeRateProvider provider) {
    String sortBy = key == '名称'
        ? 'symbol'
        : key == '交易额'
            ? 'volume'
            : 'change';
    provider.setSorting(sortBy, ascending: _sortAscExchange[key]!);
    _sortAscExchange[key] = !_sortAscExchange[key]!;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    final textColor = isLight ? Colors.black : Colors.white;
    final subTextColor = isLight ? Colors.grey[700] : Colors.grey[400];
    final dividerColor = isLight ? Colors.grey.withOpacity(0.3) : Colors.grey[700];

    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isLight ? Colors.white : const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 切换栏
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(4, (index) {
                  final labels = ['主流币', '热门榜', '涨幅榜', '交易所'];
                  final isSelected = _selectedIndex == index;
                  final labelColor = isSelected ? textColor : subTextColor;

                  return SizedBox(
                    width: 80,
                    child: GestureDetector(
                      onTap: () => _onTextClicked(index),
                      child: Column(
                        children: [
                          Text(
                            labels[index],
                            style: TextStyle(
                              fontSize: 16,
                              color: labelColor,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              height: 2,
                              width: 40,
                              color: const Color.fromRGBO(237, 176, 35, 1),
                              margin: const EdgeInsets.only(top: 4),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Container(height: 1, color: dividerColor),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<ExchangeRateProvider>(
              builder: (context, provider, _) {
                // 如果有coinList数据且选择的是主流币，使用合并数据
                if (widget.coinList != null && _selectedIndex == 0) {
                  return _buildCombinedTable(textColor, subTextColor);
                }
                
                // 否则使用原有逻辑
                final coinList = provider.filteredData.where((e) => e.isCrypto).toList();
                final exchangeList = provider.filteredData.where((e) => e.isForex).toList();

                if (_selectedIndex == 3 || _selectedIndex == 1 || _selectedIndex == 2) {
                  return _buildExchangeTable(exchangeList, textColor, subTextColor, provider);
                } else {
                  return _buildCoinTable(coinList, textColor, subTextColor, provider);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // 新的合并数据表格
  Widget _buildCombinedTable(Color textColor, Color? subTextColor) {
    if (widget.isLoading == true) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_combinedData.isEmpty) {
      return Center(
        child: Text(
          '暂无数据',
          style: TextStyle(color: textColor),
        ),
      );
    }

    return Column(
      children: [
        // 表头
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _onSortCombinedData('名称'),
                  child: Row(
                    children: [
                      Text('名称', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      Icon(
                        _sortAscCoin['名称']! ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: subTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _onSortCombinedData('价格'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('价格', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      Icon(
                        _sortAscCoin['价格']! ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: subTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _onSortCombinedData('涨幅比'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('涨幅比', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      Icon(
                        _sortAscCoin['涨幅比']! ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: subTextColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // 表格内容
        Expanded(
          child: ListView.builder(
            itemCount: _combinedData.length,
            itemBuilder: (context, index) {
              final item = _combinedData[index];

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    // 使用API数据中的icon1
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
                    // 货币名称（固定显示）
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                                color: textColor?.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // 价格（WebSocket数据）
                    Expanded(
                      flex: 1,
                      child: item.hasRealTimeData && item.currentPrice != null
                          ? Text(
                              '¥${item.currentPrice!.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: textColor),
                            )
                          : Text(
                              '--',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: textColor?.withOpacity(0.5)),
                            ),
                    ),
                    // 涨跌幅（WebSocket数据）
                    Expanded(
                      flex: 1,
                      child: item.hasRealTimeData && item.priceChangePercent != null
                          ? Consumer<ChangeColorProvider>(
                              builder: (context, colorProvider, _) {
                                final mode = colorProvider.mode;
                                final isUp = item.priceChangePercent! >= 0;

                                Color valueColor;
                                if (mode == ChangeColorMode.greenUpRedDown) {
                                  valueColor = isUp ? Colors.green : Colors.red;
                                } else {
                                  valueColor = isUp ? Colors.red : Colors.green;
                                }

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
                              style: TextStyle(color: textColor?.withOpacity(0.5)),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 保留原有的币种表格（用于其他选项卡）
  Widget _buildCoinTable(List coinList, Color textColor, Color? subTextColor, ExchangeRateProvider provider) {
    if (coinList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // 表头
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _onSortCoin('名称', provider),
                  child: Row(
                    children: [
                      Text('名称', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      Icon(
                        _sortAscCoin['名称']! ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: subTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _onSortCoin('价格', provider),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('价格', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      Icon(
                        _sortAscCoin['价格']! ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: subTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _onSortCoin('涨幅比', provider),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('涨幅比', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      Icon(
                        _sortAscCoin['涨幅比']! ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: subTextColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // 表格内容
        Expanded(
          child: ListView.builder(
            itemCount: coinList.length,
            itemBuilder: (context, index) {
              final item = coinList[index];
              final change = item.percentChange;

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Image.network(
                      item.iconUrl,
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 20,
                          height: 20,
                          color: Colors.grey[300],
                          child: const Icon(Icons.currency_bitcoin, size: 16),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: Text(item.displayName, style: TextStyle(color: textColor))),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '¥${item.price.toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<ChangeColorProvider>(
                        builder: (context, colorProvider, _) {
                          final mode = colorProvider.mode;
                          final isUp = change >= 0;

                          Color valueColor;
                          if (mode == ChangeColorMode.greenUpRedDown) {
                            valueColor = isUp ? Colors.green : Colors.red;
                          } else {
                            valueColor = isUp ? Colors.red : Colors.green;
                          }

                          return Text(
                            '${change.toStringAsFixed(2)}%',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: valueColor),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 保留原有的交易所表格
  Widget _buildExchangeTable(List exchangeList, Color textColor, Color? subTextColor, ExchangeRateProvider provider) {
    if (exchangeList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('暂无交易所数据', style: TextStyle(color: textColor)),
            const SizedBox(height: 10),
            Text('请切换到其他选项卡', style: TextStyle(color: subTextColor)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _onSortExchange('名称', provider),
                  child: Row(
                    children: [
                      Text('名称', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      Icon(
                        _sortAscExchange['名称']! ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: subTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _onSortExchange('交易额', provider),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('交易额', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      Icon(
                        _sortAscExchange['交易额']! ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: subTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _onSortExchange('评分', provider),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('评分', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      Icon(
                        _sortAscExchange['评分']! ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: subTextColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: exchangeList.length,
            itemBuilder: (context, index) {
              final item = exchangeList[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text(item.displayName, style: TextStyle(color: textColor))),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.volume.toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${(item.percentChange * 100).toInt()}%',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}