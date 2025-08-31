import 'package:flutter/material.dart';
import '../../../../../localization/i18n/lang.dart';

class EmptyStateWidget extends StatelessWidget {
  final Color textColor;
  final Color? subTextColor;

  const EmptyStateWidget({
    Key? key,
    required this.textColor,
    required this.subTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Lang.t('no_data'),
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            Lang.t('switch_other_tab'),
            style: TextStyle(color: subTextColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
