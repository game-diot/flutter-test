import 'package:flutter/material.dart';
import '../models/symbol_item.dart';
import '../services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    // 直接使用传入的 coinList，不再重复请求
    _coinList = widget.coinList;
    // 如果需要交易所数据，可以在这里单独请求
    // _fetchExchangeData();
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
    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 切换栏
          /// 切换栏 + 分割线
Column(
  children: [
    Row(
  mainAxisAlignment: MainAxisAlignment.start, // 从左排列
  children: List.generate(4, (index) {
    final labels = ['主流币', '热门榜', '涨幅榜', '交易所'];
    final isSelected = _selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color textColor = isDark
        ? Colors.white.withOpacity(isSelected ? 1.0 : 0.7)
        : (isSelected ? Colors.black : Colors.grey);
    Color borderColor = Color.fromRGBO(237, 176, 35, 1);

    return SizedBox(
      width: 80, // 固定宽度
      child: GestureDetector(
        onTap: () => _onTextClicked(index),
        child: Column(
          children: [
            Text(
              labels[index],
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                height: 2,
                width: 40,
                color: borderColor,
                margin: EdgeInsets.only(top: 4),
              ),
          ],
        ),
      ),
    );
  }),
),

    SizedBox(height: 8),
    
    // 分割线
    Container(
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    ),
  ],
),


          SizedBox(height: 8),

          /// 表格内容
          Expanded(
            child: _selectedIndex == 3
                ? _buildExchangeTable()
                : _buildCoinTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinTable() {
    if (_coinList.isEmpty) {
      return Center(child: CircularProgressIndicator());
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
                  onTap: () => _onSortCoin('名称'),
                  child: Row(
                    children: [
                      Text('名称', style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(
                        _sortAscCoin['名称']!
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
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
                      Text('价格', style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(
                        _sortAscCoin['价格']!
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
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
                      Text('涨幅比', style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(
                        _sortAscCoin['涨幅比']!
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
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
            itemCount: _coinList.length,
            itemBuilder: (context, index) {
              final item = _coinList[index];
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
                    Expanded(flex: 2, child: Text(item.alias)),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '¥${item.miniKlinePriceList.isNotEmpty ? item.miniKlinePriceList[0].toStringAsFixed(2) : "0.00"}',
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.miniKlinePriceList.length > 1 ? item.miniKlinePriceList[1].toStringAsFixed(2) : "0.00"}%',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: item.miniKlinePriceList.length > 1 && item.miniKlinePriceList[1] >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
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

  Widget _buildExchangeTable() {
    if (_exchangeList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('暂无交易所数据'),
            SizedBox(height: 10),
            Text('请切换到其他选项卡', style: TextStyle(color: Colors.grey)),
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
                      Text('名称', style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(
                        _sortAscExchange['名称']!
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
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
                      Text('交易额', style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(
                        _sortAscExchange['交易额']!
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
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
                      Text('评分', style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(
                        _sortAscExchange['评分']!
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
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
                    Expanded(flex: 2, child: Text(item.alias)),
                    Expanded(
                      flex: 1, 
                      child: Text(
                        '${item.volume24h.toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${(item.priceAccuracy * 100).toInt()}%',
                        textAlign: TextAlign.right,
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