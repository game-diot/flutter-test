import 'package:flutter/material.dart';

class SettingItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<String>? options; // 可选择的值
  final bool isArrow;

  const SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.options,
    this.isArrow = false,
  }) : super(key: key);

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  late String currentSubtitle;

  @override
  void initState() {
    super.initState();
    currentSubtitle = widget.subtitle ?? '';
  }

  void _showOptions() async {
    if (widget.options == null || widget.options!.isEmpty) return;

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return ListView(
          children: widget.options!
              .map(
                (option) => ListTile(
                  title: Text(option),
                  onTap: () => Navigator.pop(context, option),
                ),
              )
              .toList(),
        );
      },
    );

    if (selected != null) {
      setState(() {
        currentSubtitle = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: _showOptions,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(widget.icon, color: isDark ? Colors.white : Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            if (currentSubtitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  currentSubtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ),
            if (widget.isArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark ? Colors.white : Colors.grey[700],
              ),
          ],
        ),
      ),
    );
  }
}
