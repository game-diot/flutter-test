import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/login/login.dart';
import '../../login_register_page/splash_screen.dart';
import '../components/setting_item.dart';
import '../../../localization/lang.dart';

class LogoutItem extends StatelessWidget {
  const LogoutItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingItem(
      icon: SvgPicture.asset(
        'assets/svgs/lock.svg',
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          BlendMode.srcIn,
        ),
      ),
      title: Lang.t('logout_account'),
      isArrow: true,
      onTap: () async {
        final authProvider =
            Provider.of<AuthProvider>(context, listen: false);
        await authProvider.logout();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false,
        );
      },
    );
  }
}
