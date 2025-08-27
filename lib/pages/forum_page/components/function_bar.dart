// lib/forum_page/components/forum_function_bar.dart
import 'package:flutter/material.dart';

class ForumFunctionBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ForumFunctionBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton(context, "assets/images/hot.png", "今日热门"),
        _buildButton(context, "assets/images/week.png", "每周必看"),
        _buildButton(context, "assets/images/topic.png", "热议话题"),
        _buildButton(context, "assets/images/fake.png", "辟谣专区"),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {}, // 回调
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color.fromARGB(255, 255, 255, 255) : Colors.white,
              border: Border.all(
                color: const Color.fromRGBO(134, 144, 156, 0.4),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              width: 30, // 调整图片显示宽度
              height: 30, // 调整图片显示高度
              child: Image.asset(icon, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? const Color.fromRGBO(223, 229, 236, 1)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
