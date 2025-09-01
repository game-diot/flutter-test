import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/setting_item.dart';
import '../../../localization/i18n/lang.dart';

class FeedbackItem extends StatelessWidget {
  const FeedbackItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingItem(
      icon: SvgPicture.asset(
        'assets/svgs/email.svg',
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          BlendMode.srcIn,
        ),
      ),
      title: Lang.t('feedback'),
      isArrow: true,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Lang.t('feedback_not_implemented'))),
        );
      },
    );
  }
}
