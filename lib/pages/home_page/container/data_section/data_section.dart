import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import '../../../../providers/exchange/exchange.dart';
import '../../../../network/Get/models/home_page/home_data_section.dart';
import '../../../../localization/i18n/lang.dart';
import '../../../coin_detail_page/coin_detail_page.dart';
import 'controllers/data_section_controller.dart';
import 'widgets/data_section_header.dart';
import 'widgets/combined_table.dart';
import 'widgets/empty_state.dart';

/// DataSection 主组件
class DataSection extends StatefulWidget {
  final List<SymbolItem>? coinList;
  final bool? isLoading;

  const DataSection({Key? key, this.coinList, this.isLoading})
    : super(key: key);

  @override
  _DataSectionState createState() => _DataSectionState();
}

class _DataSectionState extends State<DataSection> {
  late DataSectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DataSectionController();
    _controller.initWebSocket();
    _controller.addListener(_onControllerChange);
    _controller.updateCombinedData(widget.coinList);
  }

  void _onControllerChange() {
    if (!mounted) return;
    setState(() {
      // 状态更新会触发重建
    });
  }

  @override
  void didUpdateWidget(DataSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coinList != widget.coinList) {
      _controller.updateCombinedData(widget.coinList);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }

  void _onSortPressed(String key) {
    final originalKeyMap = {
      Lang.t('name'): '名称',
      Lang.t('price'): '价格',
      Lang.t('price_change_percent'): '涨幅比',
    };
    _controller.onSortCombinedData(originalKeyMap[key]!);
  }

  @override
  Widget build(BuildContext context) {
    final isLight = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    final textColor = isLight ? Colors.black : Colors.white;
    final subTextColor = isLight ? Colors.grey[700] : Colors.grey[400];

    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isLight ? Colors.white : const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataSectionHeader(
            selectedIndex: _controller.selectedIndex,
            onTabChanged: _controller.onTabChanged,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<ExchangeRateProvider>(
              builder: (context, provider, _) {
                return _buildTableContent(provider, textColor, subTextColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent(
    ExchangeRateProvider provider,
    Color textColor,
    Color? subTextColor,
  ) {
    if (widget.coinList != null && _controller.selectedIndex == 0) {
      final translatedSortKeys = {
        Lang.t('name'): _controller.sortAscCoin['名称']!,
        Lang.t('price'): _controller.sortAscCoin['价格']!,
        Lang.t('price_change_percent'): _controller.sortAscCoin['涨幅比']!,
      };

      return CombinedTable(
        data: _controller.combinedData,
        isLoading: widget.isLoading == true,
        sortAscending: translatedSortKeys,
        onSort: _onSortPressed,
        textColor: textColor,
        subTextColor: subTextColor,
        onRowTap: (coin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SocketBindPage(coin: coin)),
          );
        },
      );
    }

    return EmptyStateWidget(textColor: textColor, subTextColor: subTextColor);
  }
}
