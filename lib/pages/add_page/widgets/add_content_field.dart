import 'package:flutter/material.dart';

class AddContentField extends StatelessWidget {
  const AddContentField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: '请输入内容（选填）',
        border: InputBorder.none,
      ),
    );
  }
}
