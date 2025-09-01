import 'package:flutter/material.dart';
import 'language_list_tile.dart';

class LanguageList extends StatelessWidget {
  final List<dynamic> languages;
  final String currentCode;
  final String? switchingCode;
  final void Function(String code, String name) onSwitch;

  const LanguageList({
    super.key,
    required this.languages,
    required this.currentCode,
    required this.switchingCode,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: languages.length,
      itemBuilder: (context, index) {
        final lang = languages[index];
        return LanguageListTile(
          lang: lang,
          currentCode: currentCode,
          switchingCode: switchingCode,
          onTap: () => onSwitch(lang['code'], lang['name']),
        );
      },
    );
  }
}
