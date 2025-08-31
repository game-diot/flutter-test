import 'package:flutter/material.dart';

class CoinIcon extends StatelessWidget {
  final String iconUrl;
  final double size;

  const CoinIcon({Key? key, required this.iconUrl, this.size = 28})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      iconUrl,
      width: size,
      height: size,
      errorBuilder: (_, __, ___) => Container(
        width: size + 2,
        height: size + 2,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.currency_bitcoin,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
