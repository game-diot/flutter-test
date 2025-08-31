import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/color/color.dart';
import '../../../../../providers/exchange/exchange.dart';
import '../../../../../localization/i18n/lang.dart';

/// 币种表格组件
class CoinTable extends StatelessWidget {
  final List coinList;
  final Map<String, bool> sortAscending;
  final Function(String, ExchangeRateProvider) onSort;
  final Color textColor;
  final Color? subTextColor;
  final ExchangeRateProvider provider;

  const CoinTable({
    Key? key,
    required this.coinList,
    required this.sortAscending,
    required this.onSort,
    required this.textColor,
    required this.subTextColor,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (coinList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(children: [_buildHeader(), _buildContent()]);
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildSortableHeader(Lang.t('name'), flex: 2),
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
        onTap: () => onSort(title, provider),
        child: Row(
          mainAxisAlignment: alignment ?? MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: Color.fromRGBO(134, 144, 156, 1),
              ),
            ),
            Icon(
              sortAscending[title] == true
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 16,
              color: Color.fromRGBO(134, 144, 156, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: ListView.builder(
        itemCount: coinList.length,
        itemBuilder: (context, index) {
          final item = coinList[index];
          final change = item.percentChange;

          return InkWell(
            onTap: () {
              // Navigator.push(
              //   // context,
              //   // MaterialPageRoute(
              //   //   builder: (_) => CoinDetailPage(
              //   //     coin: item, // 方式一：直接传整个对象
              //   //     // coinId: item.id, // 方式二：只传id，详情页自己请求
              //   //   ),
              //   // ),
              // );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Image.network(
                    item.iconUrl,
                    width: 30,
                    height: 30,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 20,
                        height: 20,
                        color: Colors.grey[300],
                        child: const Icon(Icons.currency_bitcoin, size: 30),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.displayName,
                      style: TextStyle(color: textColor, fontSize: 12),
                    ),
                  ),
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
            ),
          );
        },
      ),
    );
  }
}
