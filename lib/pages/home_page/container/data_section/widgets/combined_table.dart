import 'package:flutter/material.dart';
import '../../../../../localization/i18n/lang.dart';
import '../models/combined_coin_data.dart';
import 'table_row.dart' as coin_table;
import 'sortable_header.dart';

/// 合并数据表格组件
class CombinedTable extends StatelessWidget {
  final List<CombinedCoinData> data;
  final bool isLoading;
  final Map<String, bool> sortAscending;
  final Function(String) onSort;
  final Color textColor;
  final Color? subTextColor;
  final Function(CombinedCoinData)? onRowTap;

  const CombinedTable({
    Key? key,
    required this.data,
    required this.isLoading,
    required this.sortAscending,
    required this.onSort,
    required this.textColor,
    required this.subTextColor,
    this.onRowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (data.isEmpty)
      return Center(
        child: Text(Lang.t('no_data'), style: TextStyle(color: textColor)),
      );

    return Column(children: [_buildHeader(), _buildContent()]);
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          _buildSortableHeader(
            Lang.t('name'),
            flex: 2,
            alignment: MainAxisAlignment.start,
          ),
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
    return SortableHeader(
      title: title,
      flex: flex,
      alignment: alignment ?? MainAxisAlignment.start,
      sortAscending: sortAscending[title],
      onTap: () => onSort(title),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Transform.translate(
        offset: const Offset(-8, 0),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => coin_table.CoinTableRow(
            item: data[index],
            textColor: textColor,
            onRowTap: onRowTap,
          ),
        ),
      ),
    );
  }
}
