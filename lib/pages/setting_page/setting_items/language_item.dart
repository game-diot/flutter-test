import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/language/language.dart';
import '../components/setting_item.dart';
import '../../setting_item_detail_page/change_language_detail_page/language_page.dart'; // 引入独立语言页面
import '../../../localization/lang.dart';

class LanguageItem extends StatelessWidget {
  const LanguageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final iconColor = isDark ? Colors.white : Colors.black;

        return SettingItem(
          icon: SvgPicture.asset(
            'assets/svgs/earth.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          title: Lang.t('switch_language'),
          subtitle: languageProvider.language, // 显示当前选中语言
          isArrow: true,
          targetPage: const LanguagePage(), // 跳转到独立页面
        );
      },
    );
  }
}
