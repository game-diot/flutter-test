import 'package:flutter/material.dart';

class LanguageLoadingBanner extends StatelessWidget {
  final Color color;

  const LanguageLoadingBanner({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: color.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(width: 8),
          Text('正在加载翻译包...', style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
