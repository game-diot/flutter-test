
import 'package:flutter/material.dart';
import '../../../../../providers/exchange/exchange.dart';

/// 交易所表格组件
class ExchangeTable extends StatelessWidget {
  final List exchangeList;
  final Map<String, bool> sortAscending;
  final Function(String, ExchangeRateProvider) onSort;
  final Color textColor;
  final Color? subTextColor;
  final ExchangeRateProvider provider;

  const ExchangeTable({
    Key? key,
    required this.exchangeList,
    required this.sortAscending,
    required this.onSort,
    required this.textColor,
    required this.subTextColor,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        _buildHeader(),
        _buildContent(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildSortableHeader('名称', flex: 2),
          _buildSortableHeader('交易额', flex: 1, alignment: MainAxisAlignment.end),
          _buildSortableHeader('评分', flex: 1, alignment: MainAxisAlignment.end),
        ],
      ),
    );
  }

  Widget _buildSortableHeader(String title, {int flex = 1, MainAxisAlignment? alignment}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => onSort(title, provider),
        child: Row(
          mainAxisAlignment: alignment ?? MainAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            Icon(
              sortAscending[title] == true ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
              color: subTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: ListView.builder(
        itemCount: exchangeList.length,
        itemBuilder: (context, index) {
          final item = exchangeList[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2, 
                  child: Text(item.displayName, style: TextStyle(color: textColor))
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${item?.volume.toStringAsFixed(2)}',
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
    );
  }
}