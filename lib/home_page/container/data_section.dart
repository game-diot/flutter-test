// lib/home_page/data_section.dart
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/color/color.dart';
import '../../providers/exchange/exchange.dart';

class CoinRow extends StatelessWidget {
  final String symbol; // 固定标识
  final String displayName;
  final String iconUrl;

  const CoinRow({
    required this.symbol,
    required this.displayName,
    required this.iconUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
  child: Consumer<ExchangeRateProvider>(
    builder: (context, provider, _) {
      final allData = provider.filteredData; // 获取所有数据
      if (allData.isEmpty) return const Center(child: CircularProgressIndicator());

      return ListView.builder(
        itemCount: allData.length,
        itemBuilder: (context, index) {
          final data = allData[index];
          final change = data.percentChange;
          final isUp = change >= 0;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // 左侧固定名称列
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Image.network(
                        data.iconUrl,
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
                      Text(
                        data.displayName,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                // 右侧动态列
                Expanded(
                  flex: 1,
                  child: Text(
                    '¥${data.price.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${change.toStringAsFixed(2)}%',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: isUp ? Colors.green : Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  ),
);
  }}

class DataSection extends StatefulWidget {
  const DataSection({Key? key}) : super(key: key);

  @override
  _DataSectionState createState() => _DataSectionState();
}

class _DataSectionState extends State<DataSection> {
  int _selectedIndex = 0;

  Map<String, bool> _sortAscCoin = {'名称': true, '价格': true, '涨幅比': true};
  Map<String, bool> _sortAscExchange = {'名称': true, '交易额': true, '评分': true};

  void _onTextClicked(int index) {
    setState(() {
      _selectedIndex = index;
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
