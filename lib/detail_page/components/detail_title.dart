import 'package:flutter/material.dart';

class DetailTitle extends StatelessWidget {
  final String title;

  const DetailTitle({super.key, required this.title});

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Align(
      alignment: Alignment.centerLeft, // 明确靠左
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

}
