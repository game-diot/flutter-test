import 'package:flutter/material.dart';

class SwitchButtons extends StatelessWidget {
  final bool isFirstSelected;
  final List<String> labels;
  final ValueChanged<bool> onSwitch;

  const SwitchButtons({
    Key? key,
    required this.isFirstSelected,
    required this.labels,
    required this.onSwitch,
  }) : assert(labels.length == 2, "必须传入两个按钮文字"),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => onSwitch(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFirstSelected ? Colors.white : const Color(0xFFF4F4F5),
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(labels[0]),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => onSwitch(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: !isFirstSelected ? Colors.white : const Color(0xFFF4F4F5),
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(labels[1]),
            ),
          ),
        ],
      ),
    );
  }
}
