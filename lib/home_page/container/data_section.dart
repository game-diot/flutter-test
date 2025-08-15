import 'package:flutter/material.dart';

class DataSection extends StatefulWidget {
  @override
  _DataSectionState createState() => _DataSectionState();
}

class _DataSectionState extends State<DataSection> {
  int _selectedIndex = 0; // 用来跟踪选中的文字索引

  // 假设的数据，用来展示
  final List<Map<String, String>> _data = [
    {'人民币': '¥100', '价格': '200', '涨幅比': '10%'},
    {'人民币': '¥200', '价格': '300', '涨幅比': '15%'},
    {'人民币': '¥150', '价格': '250', '涨幅比': '12%'},
  ];

  // 用于点击时改变横线显示
  void _onTextClicked(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 上层文字和横线
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => _onTextClicked(0),
              child: Column(
                children: [
                  Text('主流币', style: TextStyle(fontSize: 16)),
                  if (_selectedIndex == 0)
                    Container(
                      height: 2,
                      width: 40,
                      color: Colors.blue,
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _onTextClicked(1),
              child: Column(
                children: [
                  Text('热门榜', style: TextStyle(fontSize: 16)),
                  if (_selectedIndex == 1)
                    Container(
                      height: 2,
                      width: 40,
                      color: Colors.blue,
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _onTextClicked(2),
              child: Column(
                children: [
                  Text('涨幅榜', style: TextStyle(fontSize: 16)),
                  if (_selectedIndex == 2)
                    Container(
                      height: 2,
                      width: 40,
                      color: Colors.blue,
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _onTextClicked(3),
              child: Column(
                children: [
                  Text('交易所', style: TextStyle(fontSize: 16)),
                  if (_selectedIndex == 3)
                    Container(
                      height: 2,
                      width: 40,
                      color: Colors.blue,
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20), // 添加间距
        // 下层表格
        Table(
          border: TableBorder.all(color: Colors.black), // 表格边框
          children: [
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('人民币'),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('价格'),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('涨幅比'),
                )),
              ],
            ),
            ..._data.map((item) {
              return TableRow(
                children: [
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item['人民币']!),
                  )),
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item['价格']!),
                  )),
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item['涨幅比']!),
                  )),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }
}
