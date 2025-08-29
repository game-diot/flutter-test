import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/color/color.dart';
import '../../setting_item_detail_page/change_up_down_color_page/up_down_color_page.dart';
import '../components/setting_item.dart';
import '../../../localization/lang.dart';
class ChangeColorItem extends StatelessWidget {
  const ChangeColorItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeColorProvider>(
      builder: (context, colorProvider, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final iconColor = isDark ? Colors.white : Colors.black;

        final arrowSvg = colorProvider.mode == ChangeColorMode.greenUpRedDown
            ? 'assets/svgs/green_red.svg'
            : 'assets/svgs/red_green.svg';

        return SettingItem(
          icon: SvgPicture.asset(
            'assets/svgs/change.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          title: Lang.t('trend_color'),
          subtitleWidget: SvgPicture.asset(
            arrowSvg,
            width: 28,
            height: 18,
          ),
          subtitle: colorProvider.subtitle,
          isArrow: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const TrendColorDetailPage()),
            );
          },
        );
      },
    );
  }
}
