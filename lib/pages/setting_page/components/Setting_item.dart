import 'package:flutter/material.dart';

class SettingItem extends StatefulWidget {
  final Widget icon;
  final String title;
  final Widget? targetPage;
  final String? subtitle;

  final Widget? subtitleWidget; // 新增
  final List<String>? options;
  final bool isArrow;
  final void Function(String)? onSelected;
  final VoidCallback? onTap;

  const SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    this.targetPage,
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
    // 1. 如果指定了 targetPage，优先跳转独立页面
    if (widget.targetPage != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget.targetPage!),
      );
      return;
    }

    // 3. 否则走 onTap 回调
    widget.onTap?.call();
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
            widget.icon,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
              ),
            ),
            if (widget.subtitleWidget != null)
              widget.subtitleWidget!
            else if (currentSubtitle != null && currentSubtitle!.isNotEmpty)
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
