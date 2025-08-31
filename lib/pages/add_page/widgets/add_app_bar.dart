import 'package:flutter/material.dart';
import '../../../../../localization/i18n/lang.dart';

class AddAppBar extends StatelessWidget {
  final VoidCallback onBackPressed;

  const AddAppBar({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackPressed,
        ),
        Expanded(
          child: Center(
            child: Text(
              Lang.t('publish'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 48), // 保持右侧空白对齐
      ],
    );
  }
}
