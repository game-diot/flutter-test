
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/color/color.dart';
import '../models/combined_coin_data.dart';

/// 合并数据表格组件
class CombinedTable extends StatelessWidget {
  final List<CombinedCoinData> data;
  final bool isLoading;
  final Map<String, bool> sortAscending;
  final Function(String) onSort;
  final Color textColor;
  final Color? subTextColor;

  const CombinedTable({
    Key? key,
    required this.data,
    required this.isLoading,
    required this.sortAscending,
    required this.onSort,
    required this.textColor,
    required this.subTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return Center(
        child: Text(
          '暂无数据',
          style: TextStyle(color: textColor),
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
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
      child: Row(
        children: [
          _buildSortableHeader('名称', flex: 2, alignment: MainAxisAlignment.start),
          _buildSortableHeader('价格', flex: 1, alignment: MainAxisAlignment.end),
          _buildSortableHeader('涨幅比', flex: 1, alignment: MainAxisAlignment.end),
        ],
      ),
    );
  }

  Widget _buildSortableHeader(String title, {int flex = 1, MainAxisAlignment? alignment}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => onSort(title),
        child: Row(
          mainAxisAlignment: alignment ?? MainAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w100, color: Color.fromRGBO(134, 144, 156,1))),
            Icon(
              sortAscending[title] == true ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
              color: Color.fromRGBO(134, 144, 156,1),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildContent() {
  return Expanded(
    child: Transform.translate(
      offset: const Offset(-8, 0), // 整体向左移动4像素
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return _buildTableRow(item);
        },
      ),
    ),
  );
}


  Widget _buildTableRow(CombinedCoinData item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
      child: Row(
        children: [
          _buildCoinIcon(item.icon1),
          const SizedBox(width: 8),
          _buildCoinName(item),
          _buildPrice(item),
          _buildPriceChange(item),
        ],
      ),
    );
  }

  Widget _buildCoinIcon(String iconUrl) {
    return Image.network(
      iconUrl,
      width: 30,
      height: 30,
      errorBuilder: (context, error, stackTrace) {
        return Container(
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
        );
      },
    );
  }

  Widget _buildCoinName(CombinedCoinData item) {
    return Expanded(
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
                color: textColor.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

 Widget _buildPrice(CombinedCoinData item) {
  return Expanded(
    flex: 1,
    child: Padding(
      padding: const EdgeInsets.only(right: 2), // 右边留点空，让文本看起来左移
      child: Align(
        alignment: Alignment.centerRight, // 保持右对齐
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
  );
}

  Widget _buildPriceChange(CombinedCoinData item) {
    return Expanded(
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
              style: TextStyle(color: textColor.withOpacity(0.5)),
            ),
    );
  }
}