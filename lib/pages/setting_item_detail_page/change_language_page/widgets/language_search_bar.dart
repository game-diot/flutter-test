import 'package:flutter/material.dart';

class LanguageSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const LanguageSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromRGBO(241, 245, 249, 1),
          prefixIcon: const Icon(Icons.search),
          hintText: '搜索',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 8,
          ),
        ),
      ),
    );
  }
}
