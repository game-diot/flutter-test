import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericInputWithLabel extends StatelessWidget {
  final TextEditingController controller;
  final String suffixText;
  final double maxValue;
  final ValueChanged<double>? onChanged; // 输入变化回调

  const NumericInputWithLabel({
    super.key,
    required this.controller,
    this.suffixText = "open",
    this.maxValue = 9999999999,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28, // 可以微调高度
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10), // 最多10位
              ],
              decoration: const InputDecoration(
                hintText: "数量",
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(fontSize: 16),
              onChanged: (val) {
                double number = double.tryParse(val) ?? 0;
                if (number > maxValue) {
                  number = maxValue;
                  controller.text = number.toStringAsFixed(0);
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length),
                  );
                }
                if (onChanged != null) onChanged!(number);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              suffixText,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
