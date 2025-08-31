import 'package:flutter/material.dart';
import '../../../../../localization/i18n/lang.dart';

class AddPublishButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddPublishButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFedb023),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          Lang.t('publish'),
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(41, 46, 56, 1),
          ),
        ),
      ),
    );
  }
}
