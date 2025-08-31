import 'package:flutter/material.dart';
import '../../../localization/i18n/lang.dart';

class ForumFunctionBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ForumFunctionBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buildButton(String icon, String label) {
      return GestureDetector(
        onTap: () {}, // 可回调
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : Colors.white,
                border: Border.all(
                  color: const Color.fromRGBO(134, 144, 156, 0.4),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(icon, fit: BoxFit.contain),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildButton("assets/images/hot.png", Lang.t("today_hot")),
        buildButton("assets/images/week.png", Lang.t("weekly_must")),
        buildButton("assets/images/topic.png", Lang.t("hot_topics")),
        buildButton("assets/images/fake.png", Lang.t("fake_news")),
      ],
    );
  }
}
