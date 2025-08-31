import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/language/language.dart';

class CompactResetToChineseButton extends StatelessWidget {
  final Color? iconColor;
  final double? iconSize;

  const CompactResetToChineseButton({
    Key? key,
    this.iconColor,
    this.iconSize = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final isCurrentlyChinese = languageProvider.currentCode == 'zh';

        return IconButton(
          onPressed: languageProvider.isLoading
              ? null
              : () async {
                  await languageProvider.resetToDefaultChinese();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('已恢复中文'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
          icon: languageProvider.isLoading
              ? SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  isCurrentlyChinese ? Icons.translate : Icons.refresh,
                  color:
                      iconColor ??
                      (isCurrentlyChinese ? Colors.green : Colors.orange),
                  size: iconSize,
                ),
          tooltip: isCurrentlyChinese ? '当前中文' : '恢复中文',
        );
      },
    );
  }
}
