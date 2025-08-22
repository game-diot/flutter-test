import 'package:flutter/material.dart';

class SettingItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<String>? options;
  final bool isArrow;
  final void Function(String)? onSelected;
  final VoidCallback? onTap; // 添加一个简单的点击回调

  const SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.options,
    this.isArrow = false,
    this.onSelected,
    this.onTap,
  }) : super(key: key);

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  String? currentSubtitle;

  @override
  void initState() {
    super.initState();
    currentSubtitle = widget.subtitle;
  }

  @override
  void didUpdateWidget(SettingItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subtitle != oldWidget.subtitle) {
      setState(() {
        currentSubtitle = widget.subtitle;
      });
    }
  }

  void _handleTap() async {
    // 如果有options，显示选择框
    if (widget.options != null && widget.options!.isNotEmpty) {
      final selected = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ...widget.options!.map(
                  (option) => ListTile(
                    title: Text(option),
                    trailing: currentSubtitle == option 
                        ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                        : null,
                    onTap: () => Navigator.pop(context, option),
                  ),
                ),
              ],
            ),
          );
        },
      );

      if (selected != null) {
        setState(() {
          currentSubtitle = selected;
        });
        if (widget.onSelected != null) {
          widget.onSelected!(selected);
        }
      }
    } else if (widget.onTap != null) {
      // 如果没有options但有onTap回调，直接调用
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: _handleTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(widget.icon, color: colorScheme.onSurface),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
              ),
            ),
            if (currentSubtitle != null && currentSubtitle!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  currentSubtitle!,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
            if (widget.isArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}