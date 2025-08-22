import 'package:flutter/material.dart';

class StatButton extends StatelessWidget {
  final String title;
  final String count;
  final VoidCallback? onTap;

  const StatButton({
    super.key,
    required this.title,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.4),
          width: 0.4,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.onSurface),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
