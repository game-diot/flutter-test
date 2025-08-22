import 'package:flutter/material.dart';
import 'function_button.dart';

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
    final buttons = [
      {"icon": "assets/images/hot.svg", "label": "今日热门"},
      {"icon": "assets/images/week.svg", "label": "每周必看"},
      {"icon": "assets/images/topic.svg", "label": "热议话题"},
      {"icon": "assets/images/fake.svg", "label": "辟谣专区"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          buttons.length,
          (index) {
            final btn = buttons[index];
            return FunctionButton(
              svgPath: btn["icon"]!,
              label: btn["label"]!,
              isSelected: selectedIndex == index,
              onTap: () => onSelect(index),
            );
          },
        ),
      ),
    );
  }
}
