import 'package:flutter/material.dart';

class SymbolListPage extends StatefulWidget {
  @override
  _SymbolListPageState createState() => _SymbolListPageState();
}

class _SymbolListPageState extends State<SymbolListPage> {
  // 定义一个Future类型的变量来存储币种数据响应
  late Future<Map<String, dynamic>> _futureSymbols;

  @override
  void initState() {
    super.initState();
    // 定义获取币种数据的方法
    _futureSymbols = Future<Map<String, dynamic>>.value({
      'list': [] // 初始化一个空列表作为默认值
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('币种列表')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureSymbols,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('请求出错：${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.list.isEmpty) {
            return Center(child: Text('暂无数据'));
          }

          final symbols = snapshot.data!.list;
          return ListView.builder(
            itemCount: symbols.length,
            itemBuilder: (context, index) {
              final item = symbols[index];
              return ListTile(
                leading: Image.network(item.icon1, width: 40, height: 40),
                title: Text(item.alias),
                subtitle: Text('${item.symbol} | 24h量: ${item.volume24h}'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // 点击逻辑
                },
              );
            },
          );
        },
      ),
    );
  }
}
