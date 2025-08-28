// components/items/logout_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/login/login.dart';
import '../../login_register_page/splash_screen.dart';
import '../components/setting_item.dart';

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
      title: '注销账号',
      isArrow: true,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('确认注销'),
            content: const Text('确定要注销当前账号吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  await authProvider.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const SplashScreen()),
                    (route) => false,
                  );
                },
                child: const Text('确认'),
              ),
            ],
          ),
        );
      },
    );
  }
}
