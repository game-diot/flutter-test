import 'package:flutter/material.dart';

class TopTabBarWithSwitch extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabs;
  final ValueChanged<int> onTabChanged;
  final bool switchValue;
  final ValueChanged<bool> onSwitchChanged;

  const TopTabBarWithSwitch({
    Key? key,
    required this.selectedIndex,
    required this.tabs,
    required this.onTabChanged,
    required this.switchValue,
    required this.onSwitchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左侧 Tabs
          Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () => onTabChanged(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 40,
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          // 右侧切换按钮
          IconButton(
            icon: Icon(
              switchValue ? Icons.toggle_on : Icons.toggle_off,
              size: 40,
            ),
            onPressed: () => onSwitchChanged(!switchValue),
          ),
        ],
      ),
    );
  }
}
