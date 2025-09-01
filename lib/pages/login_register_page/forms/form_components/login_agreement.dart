import 'package:flutter/material.dart';
import '../../../../localization/i18n/lang.dart';

class LoginAgreement extends StatelessWidget {
  const LoginAgreement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Lang.t('login_agree_text'),
          style: const TextStyle(color: Colors.black),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            Lang.t('terms_of_use'),
            style: const TextStyle(color: Color(0xFFedb023)),
          ),
        ),
        Text(Lang.t('slash'), style: const TextStyle(color: Colors.black)),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            Lang.t('privacy_policy'),
            style: const TextStyle(color: Color(0xFFedb023)),
          ),
        ),
      ],
    );
  }
}
