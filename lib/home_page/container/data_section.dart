import 'package:flutter/material.dart';
import '../../network/Get/models/home_page/home_data_section.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/color/color.dart';
import '../../Websocket/home_page_data_section/websocket.dart';

class DataSection extends StatefulWidget {
  final List<SymbolItem> coinList;

  const DataSection({Key? key, required this.coinList}) : super(key: key);

  @override
  _DataSectionState createState() => _DataSectionState();
}

class _DataSectionState extends State<DataSection> {
  int _selectedIndex = 0;

  List<SymbolItem> _coinList = [];
  List<SymbolItem> _exchangeList = [];

  Map<String, bool> _sortAscCoin = {'名称': true, '价格': true, '涨幅比': true};
  Map<String, bool> _sortAscExchange = {'名称': true, '交易额': true, '评分': true};

  late SymbolWebSocketService _wsService;

  @override
  void initState() {
    super.initState();
    _coinList = widget.coinList;

    _wsService = SymbolWebSocketService(
      url: 'wss://你的websocket地址',
      onData: (newData) {
        setState(() {
          _coinList = newData;
        });
      },
    );
    _wsService.connect();
  }

  @override
  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }

  void _onTextClicked(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSortCoin(String key) {
    setState(() {
      bool asc = _sortAscCoin[key]!;
      _coinList.sort((a, b) {
        switch (key) {
          case '名称':
            return asc ? a.alias.compareTo(b.alias) : b.alias.compareTo(a.alias);
          case '价格':
            return asc
                ? a.miniKlinePriceList[0].compareTo(b.miniKlinePriceList[0])
                : b.miniKlinePriceList[0].compareTo(a.miniKlinePriceList[0]);
          case '涨幅比':
            return asc
                ? a.miniKlinePriceList[1].compareTo(b.miniKlinePriceList[1])
                : b.miniKlinePriceList[1].compareTo(a.miniKlinePriceList[1]);
          default:
            return 0;
        }
      });
      _sortAscCoin[key] = !asc;
    });
  }

  void _onSortExchange(String key) {
    setState(() {
      bool asc = _sortAscExchange[key]!;
      _exchangeList.sort((a, b) {
        switch (key) {
          case '名称':
            return asc ? a.alias.compareTo(b.alias) : b.alias.compareTo(a.alias);
          case '交易额':
            return asc ? a.volume24h.compareTo(b.volume24h) : b.volume24h.compareTo(a.volume24h);
          case '评分':
            return asc
                ? a.priceAccuracy.compareTo(b.priceAccuracy)
                : b.priceAccuracy.compareTo(a.priceAccuracy);
          default:
            return 0;
        }
      });
      _sortAscExchange[key] = !asc;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;

    final textColor = isLight ? Colors.black : Colors.white;
    final subTextColor = isLight ? Colors.grey[700] : Colors.grey[400];
    final dividerColor = isLight ? Colors.grey.withOpacity(0.3) : Colors.grey[700];

    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isLight ? Colors.white : Color(0xFF1E1E1E),
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
                              color: Color.fromRGBO(237, 176, 35, 1),
                              margin: EdgeInsets.only(top: 4),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 8),
              Container(height: 1, color: dividerColor),
            ],
          ),
          SizedBox(height: 8),
          // 表格内容
          
          Expanded(
            child: (_selectedIndex == 3||_selectedIndex == 1 || _selectedIndex == 2)
                ? _buildExchangeTable(textColor, subTextColor)
                : _buildCoinTable(textColor, subTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinTable(Color textColor, Color? subTextColor) {
    if (_coinList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // 表头
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _onSortCoin('名称'),
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
                  onTap: () => _onSortCoin('价格'),
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
                  onTap: () => _onSortCoin('涨幅比'),
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
            itemCount: _coinList.length,
            itemBuilder: (context, index) {
              final item = _coinList[index];
              final change = item.miniKlinePriceList.length > 1 ? item.miniKlinePriceList[1] : 0.0;

              return Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Image.network(
                      item.icon1,
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 20,
                          height: 20,
                          color: Colors.grey[300],
                          child: Icon(Icons.currency_bitcoin, size: 16),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    Expanded(flex: 2, child: Text(item.alias, style: TextStyle(color: textColor))),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '¥${item.miniKlinePriceList.isNotEmpty ? item.miniKlinePriceList[0].toStringAsFixed(2) : "0.00"}',
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

    Widget _buildExchangeTable(Color textColor, Color? subTextColor) {
    String emptyTitle = '';
    String emptySubtitle = '';

    // 根据选中的 tab 改提示语
    if (_selectedIndex == 1) {
      emptyTitle = '暂无热门榜数据';
      emptySubtitle = '请切换到其他选项卡';
    } else if (_selectedIndex == 2) {
      emptyTitle = '暂无涨幅榜数据';
      emptySubtitle = '请切换到其他选项卡';
    } else {
      emptyTitle = '暂无交易所数据';
      emptySubtitle = '请切换到其他选项卡';
    }

    if (_exchangeList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emptyTitle, style: TextStyle(color: textColor)),
            SizedBox(height: 10),
            Text(emptySubtitle, style: TextStyle(color: subTextColor)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _onSortExchange('名称'),
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
                  onTap: () => _onSortExchange('交易额'),
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
                  onTap: () => _onSortExchange('评分'),
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
            itemCount: _exchangeList.length,
            itemBuilder: (context, index) {
              final item = _exchangeList[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text(item.alias, style: TextStyle(color: textColor))),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.volume24h.toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${(item.priceAccuracy * 100).toInt()}%',
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
