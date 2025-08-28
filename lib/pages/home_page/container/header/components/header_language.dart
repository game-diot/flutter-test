import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../setting_item_detail_page/change_language_detail_page/language_page.dart'; // 你的语言选择页路径

class HeaderLanguage extends StatelessWidget {
  const HeaderLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    // 根据主题设置图标颜色
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return IconButton(
      icon: SvgPicture.asset(
        'assets/svgs/earth.svg',
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
      onPressed: () {
        // 点击跳转到完整的语言选择页
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LanguagePage()),
        );
      },
    );
  }
}
