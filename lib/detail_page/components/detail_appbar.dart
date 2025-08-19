import 'package:flutter/material.dart';

class DetailAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const DetailAppBar({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
      title: const Text('详情'),
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    );
  }
}
