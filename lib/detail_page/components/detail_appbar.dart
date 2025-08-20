import 'package:flutter/material.dart';

class DetailAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const DetailAppBar({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final fgColor = isDark ? Colors.white : Colors.black;

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: fgColor),
        onPressed: onBack,
      ),
      title: Text(
        '详情',
        style: TextStyle(color: fgColor),
      ),
      centerTitle: true,
      backgroundColor: bgColor,
      elevation: 0,
    );
  }
}
