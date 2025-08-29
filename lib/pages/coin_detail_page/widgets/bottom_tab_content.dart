import 'package:flutter/material.dart';

class BottomTabContent extends StatefulWidget {
  const BottomTabContent({Key? key}) : super(key: key);

  @override
  State<BottomTabContent> createState() => _BottomTabContentState();
}

class _BottomTabContentState extends State<BottomTabContent> {
  int _selectedTab = 0;
  bool _checkboxValue = false;

  final List<String> _tabs = ["永续合约", "极速合约", "期权合约"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Row
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final isSelected = _selectedTab == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _tabs[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 40,
                      color: isSelected ? Colors.blue : Colors.transparent,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        const Divider(height: 1, thickness: 1),

        // 第一行：左复选框，右文字按钮
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _checkboxValue,
                    onChanged: (val) => setState(() => _checkboxValue = val ?? false),
                  ),
                  const Text("启用选项"),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text("操作按钮"),
              ),
            ],
          ),
        ),

        const Divider(height: 1, thickness: 1),

        // 内容展示区
        Expanded(
          child: Container(
            color: Colors.grey[100],
            child: Center(
              child: Text(
                "当前Tab内容：${_tabs[_selectedTab]}",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
