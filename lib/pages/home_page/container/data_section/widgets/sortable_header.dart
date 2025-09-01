import 'package:flutter/material.dart';

class SortableHeader extends StatelessWidget {
  final String title;
  final int flex;
  final MainAxisAlignment alignment;
  final bool? sortAscending;
  final VoidCallback onTap;

  const SortableHeader({
    Key? key,
    required this.title,
    this.flex = 1,
    this.alignment = MainAxisAlignment.start,
    required this.sortAscending,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: const Color.fromRGBO(134, 144, 156, 1),
              ),
            ),
            Icon(
              sortAscending == true ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
              color: const Color.fromRGBO(134, 144, 156, 1),
            ),
          ],
        ),
      ),
    );
  }
}
