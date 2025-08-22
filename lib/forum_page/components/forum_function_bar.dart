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
        _buildButton(context, 0, "assets/images/hot.svg", "今日热门"),
        _buildButton(context, 1, "assets/images/week.svg", "每周必看"),
        _buildButton(context, 2, "assets/images/topic.svg", "热议话题"),
        _buildButton(context, 3, "assets/images/fake.svg", "辟谣专区"),
      ],
    );
  }

  Widget _buildButton(BuildContext context, int index, String icon, String label) {
    final isSelected = selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onSelect(index),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              border: Border.all(color: const Color.fromRGBO(134, 144, 156, 0.4)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.star, color: isSelected ? Colors.orange : (isDark ? Colors.white : Colors.black)),
            // TODO: 换成 SvgPicture.asset(icon, ...)
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color.fromRGBO(223, 229, 236,1) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
