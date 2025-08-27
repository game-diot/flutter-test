import 'package:flutter/material.dart';

class DetailDivider extends StatelessWidget {
  const DetailDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 8,
      color: Color.fromRGBO(241, 245, 249, 1),
      height: 20,
    );
  }
}
