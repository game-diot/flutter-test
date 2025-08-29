import 'package:flutter/material.dart';
import 'components/stat_button.dart';
import 'components/ad_banner.dart';
import 'header/header.dart';
import 'setting_items/language_item.dart';
import 'setting_items/theme_item.dart';
import 'setting_items/change_color_item.dart';
import 'setting_items/feedback_item.dart';
import 'setting_items/logout_item.dart';
import '../my_article/my_likes_page.dart';
import '../my_article/my_post_page.dart';
import '../../../localization/lang.dart';

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
              children: [
                Expanded(
                  child: StatButton(
                    title: Lang.t('my_posts'),
                    count: '12',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyPostsPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatButton(
                    title: Lang.t('my_likes'),
                    count: '34',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyLikesPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AdBanner(),
          ),
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
