import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageListTile extends StatelessWidget {
  final Map lang;
  final String currentCode;
  final String? switchingCode;
  final VoidCallback onTap;

  const LanguageListTile({
    super.key,
    required this.lang,
    required this.currentCode,
    required this.switchingCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final code = lang['code'];
    final name = lang['name'];
    final avatar = lang['avatar'];

    final isSelected = code == currentCode;
    final isSwitching = switchingCode == code;

    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(avatar), radius: 16),
      title: Text(
        name,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      subtitle: isSelected
          ? Text(
              '当前语言',
              style: TextStyle(color: theme.primaryColor, fontSize: 12),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSwitching)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (isSelected)
            SvgPicture.asset(
              'assets/svgs/done.svg',
              width: 30,
              height: 30,
              color: theme.colorScheme.primary,
            ),
        ],
      ),
      onTap: isSwitching ? null : onTap,
      tileColor: isSelected ? theme.primaryColor.withOpacity(0.05) : null,
      shape: isSelected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: theme.primaryColor.withOpacity(0.3)),
            )
          : null,
    );
  }
}
