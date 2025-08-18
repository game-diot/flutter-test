import 'package:flutter/material.dart';

class DataSection extends StatefulWidget {
  @override
  _DataSectionState createState() => _DataSectionState();
}

class _DataSectionState extends State<DataSection> {
  int _selectedIndex = 0;

  // 主流币数据
  final List<Map<String, dynamic>> _coinData = [
    {'logo': Icons.ac_unit, '名称': 'BTC', '货币': '¥', '价格': 100.0, '涨幅比': 3.86},
    {'logo': Icons.ad_units, '名称': 'ETH', '货币': '¥', '价格': 200.0, '涨幅比': -5.21},
    {'logo': Icons.airplanemode_active, '名称': 'LTC', '货币': '\$', '价格': 150.0, '涨幅比': 12.34},
    {'logo': Icons.anchor, '名称': 'XRP', '货币': '\$', '价格': 120.0, '涨幅比': -8.75},
    {'logo': Icons.android, '名称': 'DOGE', '货币': '¥', '价格': 220.0, '涨幅比': 20.0},
        {'logo': Icons.ac_unit, '名称': 'BTC', '货币': '¥', '价格': 100.0, '涨幅比': 3.86},
    {'logo': Icons.ad_units, '名称': 'ETH', '货币': '¥', '价格': 200.0, '涨幅比': -5.21},
    {'logo': Icons.airplanemode_active, '名称': 'LTC', '货币': '\$', '价格': 150.0, '涨幅比': 12.34},
    {'logo': Icons.anchor, '名称': 'XRP', '货币': '\$', '价格': 120.0, '涨幅比': -8.75},
    {'logo': Icons.android, '名称': 'DOGE', '货币': '¥', '价格': 220.0, '涨幅比': 20.0},
        {'logo': Icons.ac_unit, '名称': 'BTC', '货币': '¥', '价格': 100.0, '涨幅比': 3.86},
    {'logo': Icons.ad_units, '名称': 'ETH', '货币': '¥', '价格': 200.0, '涨幅比': -5.21},
    {'logo': Icons.airplanemode_active, '名称': 'LTC', '货币': '\$', '价格': 150.0, '涨幅比': 12.34},
    {'logo': Icons.anchor, '名称': 'XRP', '货币': '\$', '价格': 120.0, '涨幅比': -8.75},
    {'logo': Icons.android, '名称': 'DOGE', '货币': '¥', '价格': 220.0, '涨幅比': 20.0},
  ];

  // 交易所数据
  final List<Map<String, dynamic>> _exchangeData = [
    {'logo': Icons.star, '名称': 'Binance', '交易额': 5465.15, '评分': 0.7},
    {'logo': Icons.star_border, '名称': 'Coinbase', '交易额': 3200.32, '评分': 0.6},
    {'logo': Icons.star_half, '名称': 'Huobi', '交易额': 2100.88, '评分': 0.8},
    {'logo': Icons.star, '名称': 'Kraken', '交易额': 1500.50, '评分': 0.75},
    {'logo': Icons.star_border, '名称': 'OKX', '交易额': 980.21, '评分': 0.65},
        {'logo': Icons.star, '名称': 'Binance', '交易额': 5465.15, '评分': 0.7},
    {'logo': Icons.star_border, '名称': 'Coinbase', '交易额': 3200.32, '评分': 0.6},
    {'logo': Icons.star_half, '名称': 'Huobi', '交易额': 2100.88, '评分': 0.8},
    {'logo': Icons.star, '名称': 'Kraken', '交易额': 1500.50, '评分': 0.75},
    {'logo': Icons.star_border, '名称': 'OKX', '交易额': 980.21, '评分': 0.65},
        {'logo': Icons.star, '名称': 'Binance', '交易额': 5465.15, '评分': 0.7},
    {'logo': Icons.star_border, '名称': 'Coinbase', '交易额': 3200.32, '评分': 0.6},
    {'logo': Icons.star_half, '名称': 'Huobi', '交易额': 2100.88, '评分': 0.8},
    {'logo': Icons.star, '名称': 'Kraken', '交易额': 1500.50, '评分': 0.75},
    {'logo': Icons.star_border, '名称': 'OKX', '交易额': 980.21, '评分': 0.65},
  ];

  Map<String, bool> _sortAscCoin = {
    '名称': true,
    '价格': true,
    '涨幅比': true,
  };

  Map<String, bool> _sortAscExchange = {
    '名称': true,
    '交易额': true,
    '评分': true,
  };

  void _onTextClicked(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSortCoin(String key) {
    setState(() {
      bool asc = _sortAscCoin[key]!;
      _coinData.sort((a, b) {
        if (key == '名称') {
          return asc
              ? a[key].toString().compareTo(b[key].toString())
              : b[key].toString().compareTo(a[key].toString());
        } else {
          double aValue = a[key] as double;
          double bValue = b[key] as double;
          return asc ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        }
      });
      _sortAscCoin[key] = !asc;
    });
  }

  void _onSortExchange(String key) {
    setState(() {
      bool asc = _sortAscExchange[key]!;
      _exchangeData.sort((a, b) {
        if (key == '名称') {
          return asc
              ? a[key].toString().compareTo(b[key].toString())
              : b[key].toString().compareTo(a[key].toString());
        } else {
          double aValue = a[key] as double;
          double bValue = b[key] as double;
          return asc ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        }
      });
      _sortAscExchange[key] = !asc;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部切换栏
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) {
              final labels = ['主流币', '热门榜', '涨幅榜', '交易所'];
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => _onTextClicked(index),
                child: Column(
                  children: [
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.black : Colors.grey,
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
              );
            }),
          ),
          SizedBox(height: 8),

          // 表格内容
          _selectedIndex == 3
              ? _buildExchangeTable()
              : _buildCoinTable(),
        ],
      ),
    );
  }

  // 主流币表格
  Widget _buildCoinTable() {
    return Expanded(
      child: Column(
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
                        Text('名称', style: TextStyle(fontWeight: FontWeight.bold)),
                        Icon(_sortAscCoin['名称']! ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
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
                        Icon(_sortAscCoin['价格']! ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => _onSortCoin('涨幅比'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('涨幅比', style: TextStyle(fontWeight: FontWeight.bold)),
                        Icon(_sortAscCoin['涨幅比']! ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey),

          Expanded(
            child: ListView.builder(
              itemCount: _coinData.length,
              itemBuilder: (context, index) {
                final item = _coinData[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Icon(item['logo'], size: 22),
                            SizedBox(width: 8),
                            Text(item['名称'], style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${item['货币']}${item['价格']}'),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${(item['涨幅比'] >= 0 ? '+' : '')}${item['涨幅比'].toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: (item['涨幅比'] as double) >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 交易所表格
  Widget _buildExchangeTable() {
  return Expanded(
    child: Column(
      children: [
        // 表头
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
                      Text('排名', style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(_sortAscExchange['名称']! ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
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
                      Icon(_sortAscExchange['交易额']! ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _onSortExchange('评分'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('综合评分', style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(_sortAscExchange['评分']! ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey),

        // 数据列表
        Expanded(
          child: ListView.builder(
            itemCount: _exchangeData.length,
            itemBuilder: (context, index) {
              final item = _exchangeData[index]; // <-- 必须在这里定义 item
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    // 排名 + 名称
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(item['logo'], size: 22),
                          SizedBox(width: 8),
                          Text(item['名称'], style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    // 交易额
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('\$${item['交易额'].toStringAsFixed(2)}亿'),
                        ],
                      ),
                    ),
                    SizedBox(width: 6),
                    // 综合评分
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: item['评分'] as double,
                                  child: Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          Text('${(item['评分'] * 100).toInt()}%'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

  }
