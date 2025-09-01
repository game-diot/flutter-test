import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../home_page/container/data_section/models/combined_coin_data.dart';
import '../models/model.dart';
import '../../../socket/home_page_data_section/exchange_depth_model.dart';
class HeaderInfo extends StatelessWidget {
  final CombinedCoinData coin;        // 父组件传的数据
  final CoinDetail coinDetail;        // API 或 socket 返回的详细数据
  final ExchangeDepth? exchangeDepth; // socket 深度数据，可选
  final bool switchValue;
  final ValueChanged<bool> onSwitchChanged;
  final bool isFullPosition;
  final ValueChanged<bool> onFullPositionChanged;
  final double sliderStepPercent;
  final ValueChanged<double> onSliderStepChanged;

  const HeaderInfo({
    Key? key,
    required this.coin,
    required this.coinDetail,
    this.exchangeDepth,
    required this.switchValue,
    required this.onSwitchChanged,
    required this.isFullPosition,
    required this.onFullPositionChanged,
    required this.sliderStepPercent,
    required this.onSliderStepChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // 第一行：币种名称 + SVG按钮，右侧数值
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 左侧：币种名称 + 涨跌百分比 + 标签 + 下拉箭头
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${coin.priceChangePercent?.toStringAsFixed(2) ?? '--'}%",
                        style: TextStyle(
                          color: (coin.priceChangePercent ?? 0) >= 0
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '永续',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),

              // 右侧：SVG按钮
              IconButton(
                iconSize: 32,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: SvgPicture.asset(
                  'assets/svgs/coin_detail.svg',
                  width: 32,
                  height: 32,
                ),
                onPressed: () => onSwitchChanged(!switchValue),
              ),
            ],
          ),

          // 合并后的行：左侧按钮组 + 右侧数值
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 左侧按钮组
              Row(
                children: [
                  _buildToggleButton(
                    text: "全仓",
                    isSelected: isFullPosition,
                    onTap: () => onFullPositionChanged(!isFullPosition),
                  ),
                  const SizedBox(width: 8),
                  _buildStepButton(),
                ],
              ),

              // 右侧数值
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "资金费率/倒计时",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "0.01%/012",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[400]!, width: 1),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStepButton() {
    return GestureDetector(
      onTap: () {
        // 切换步进比例：1% <-> 10%
        double newStep = sliderStepPercent == 1.0 ? 10.0 : 1.0;
        onSliderStepChanged(newStep);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[400]!, width: 1),
        ),
        child: Text(
          "${sliderStepPercent.toStringAsFixed(0)}%",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
