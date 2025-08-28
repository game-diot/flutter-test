// pages/setting_page.dart
import 'package:flutter/material.dart';
import 'components/stat_button.dart';
import 'components/ad_banner.dart';
import 'header/header.dart';
import 'setting_items/language_item.dart';
import 'setting_items/theme_item.dart';
import 'setting_items/change_color_item.dart';
import 'setting_items/feedback_item.dart';
import 'setting_items/logout_item.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: [
          const SettingPageHeader(),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: const [
                Expanded(child: StatButton(title: '我的帖子', count: '12', onTap: null)),
                SizedBox(width: 16),
                Expanded(child: StatButton(title: '我的点赞', count: '34', onTap: null)),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: AdBanner()),
          const SizedBox(height: 20),

          const LanguageItem(),
          const SizedBox(height: 12),
          const ThemeItem(),
          const SizedBox(height: 12),
          const ChangeColorItem(),
          const SizedBox(height: 12),
          const FeedbackItem(),
          const SizedBox(height: 12),
          const LogoutItem(),
        ],
      ),
    );
  }
}
