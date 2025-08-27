import 'package:flutter/material.dart';
import '../../header/header.dart';

class MarketHeader extends StatelessWidget {
  const MarketHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color.fromRGBO(18, 18, 18, 1) : const Color.fromARGB(255, 255, 255, 255),
      child: const Column(
        children: [
          Header(),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
