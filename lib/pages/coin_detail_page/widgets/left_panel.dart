import 'package:flutter/material.dart';
import '../../home_page/container/data_section/models/combined_coin_data.dart';
import 'left_slider.dart';
import 'left_extra_panel.dart';
import 'left_input.dart';
import 'left_dropdown_button.dart';

class LeftPanel extends StatefulWidget {
  final CombinedCoinData coin;

  const LeftPanel({Key? key, required this.coin}) : super(key: key);

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  double _currentValue = 0;
  final TextEditingController _controller = TextEditingController();

  void _onSliderChanged(double val) {
    setState(() {
      _currentValue = val;
      _controller.text = _currentValue.toStringAsFixed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ListView(
        children: [
          // 上方可用信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("可用", style: TextStyle(fontSize: 12)),
              Row(
                children: const [
                  Text(
                    "456,4546.12",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "USDT",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.swap_horiz,
                    size: 20,
                    color: Color.fromRGBO(0, 125, 255, 1),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 底部选择器
          BottomSheetSelector(options: ["市场单", "限价单"], initialValue: "市场单"),

          const SizedBox(height: 10),

          // 数字输入框
          NumericInputWithLabel(controller: _controller, suffixText: "open"),

          const SizedBox(height: 12),

          // 自定义滑块
          CustomSliderDemo(
            value: _currentValue,
            max: 9999999999,
            onChanged: _onSliderChanged,
          ),

          const SizedBox(height: 12),

          // 左侧额外面板
          LeftExtraPanel(currentValue: _currentValue),
        ],
      ),
    );
  }
}
