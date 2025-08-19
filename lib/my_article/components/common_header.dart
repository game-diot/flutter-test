// components/common_header.dart
import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
  final String title;

  const CommonHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(title, style: TextStyle(fontSize: 18)),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
    );
  }
}
