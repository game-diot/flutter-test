import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FunctionButton extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FunctionButton({
    super.key,
    required this.svgPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor = isDark ? Colors.grey[850]! : Colors.white;
    Color borderColor = const Color.fromRGBO(134, 144, 156, 0.4);
    Color iconColor = isSelected
        ? const Color.fromRGBO(237, 176, 35, 1)
        : (isDark ? Colors.white : Colors.black);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              svgPath,
              width: 30,
              height: 28,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? const Color.fromRGBO(223, 229, 236, 1)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
