import 'package:flutter/material.dart';

class DetailContent extends StatelessWidget {
  final String content;

  const DetailContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5,color: Color.fromRGBO(41, 46, 56,1)),
          ),
        ),
        
      ],
    );
  }
}
