import 'package:flutter/material.dart';
import '../../../../localization/i18n/lang.dart';

class RegisterSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final VoidCallback? onSwitchToLogin;

  const RegisterSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.onSwitchToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color.fromRGBO(244, 244, 245, 1),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    Lang.t('register'),
                    style: const TextStyle(fontSize: 18),
                  ),
          ),
        ),
        TextButton(
          onPressed: onSwitchToLogin,
          child: Text(
            Lang.t('have_account_login'),
            style: const TextStyle(color: Color(0xFFedb023), fontSize: 18),
          ),
        ),
      ],
    );
  }
}
