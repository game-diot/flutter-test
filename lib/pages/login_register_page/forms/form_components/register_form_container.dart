import 'package:flutter/material.dart';
import 'register_form_content.dart';
class RegisterFormContainer extends StatefulWidget {
  final VoidCallback? onSwitchToLogin;
  const RegisterFormContainer({this.onSwitchToLogin, Key? key}) : super(key: key);

  @override
  State<RegisterFormContainer> createState() => _RegisterFormContainerState();
}

class _RegisterFormContainerState extends State<RegisterFormContainer> {
  bool isPhoneSelected = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: screenHeight * 0.70,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),

        ),
        child: SingleChildScrollView(
          child: RegisterFormContent(
            onSwitchToLogin: widget.onSwitchToLogin,
            isPhoneSelected: isPhoneSelected,
            onSwitch: (val) => setState(() => isPhoneSelected = val),
          ),
        ),
      ),
    );
  }
}
