import 'package:flutter/material.dart';
import 'header/header.dart';
import 'components/stat_button.dart';
import 'components/ad_banner.dart';
import 'components/setting_item.dart';
import '../../my_article/my_likes_page.dart';
import '../../my_article/my_post_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: ListView(
        children: [
          // Header
          const SettingPageHeader(),
          const SizedBox(height: 20),

          // 我的帖子 / 我的点赞
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: StatButton(
                    title: '我的帖子',
                    count: '12',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyPostsPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatButton(
                    title: '我的点赞',
                    count: '34',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyLikesPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 广告 Banner
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AdBanner(),
          ),

          const SizedBox(height: 20),

          // 设置项
          const SettingItem(
            icon: Icons.language,
            title: '切换语言',
            subtitle: '简体中文',
            isArrow: true,
          ),
          SettingItem(
            icon: Icons.light_mode,
            title: '主题',
            subtitle: Theme.of(context).brightness == Brightness.dark ? '暗黑' : '明亮',
            isArrow: true,
          ),
          const SettingItem(icon: Icons.show_chart, title: '涨跌颜色', isArrow: true),
          const SettingItem(icon: Icons.feedback, title: '意见反馈', isArrow: true),
          const SettingItem(icon: Icons.logout, title: '注销账号'),
        ],
      ),
    );
  }
}
