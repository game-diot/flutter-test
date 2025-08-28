// components/items/change_color_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/color/color.dart';
import '../components/Setting_item.dart';

class ChangeColorItem extends StatelessWidget {
  const ChangeColorItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeColorProvider>(
      builder: (context, colorProvider, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final iconColor = isDark ? Colors.white : Colors.black;

        final arrowSvg =
            colorProvider.mode == ChangeColorMode.greenUpRedDown
                ? 'assets/svgs/green_red.svg'
                : 'assets/svgs/red_green.svg';

        return SettingItem(
          icon: SvgPicture.asset(
            'assets/svgs/change.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          title: '涨跌颜色',
          subtitleWidget: SvgPicture.asset(
            arrowSvg,
            width: 28,
            height: 18,
          ),
          options: const ['涨绿跌红', '涨红跌绿'],
          isArrow: true,
          onSelected: (selected) {
            if (selected == '涨绿跌红' &&
                colorProvider.mode != ChangeColorMode.greenUpRedDown) {
              colorProvider.toggleMode();
            } else if (selected == '涨红跌绿' &&
                colorProvider.mode != ChangeColorMode.redUpGreenDown) {
              colorProvider.toggleMode();
            }
          },
          onTap: colorProvider.toggleMode,
        );
      },
    );
  }
}
