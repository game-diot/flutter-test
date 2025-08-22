import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '../../providers/language/language.dart';
import '../../providers/color/color.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

          // 主题设置
          Builder(
            builder: (context) {
              String themeSubtitle;
              switch (AdaptiveTheme.of(context).mode) {
                case AdaptiveThemeMode.light:
                  themeSubtitle = '明亮';
                  break;
                case AdaptiveThemeMode.dark:
                  themeSubtitle = '暗黑';
                  break;
                case AdaptiveThemeMode.system:
                default:
                  themeSubtitle = '跟随系统';
              }

              return SettingItem(
                icon: Icons.palette,
                title: '主题',
                subtitle: themeSubtitle,
                options: const ['明亮', '暗黑', '跟随系统'],
                isArrow: true,
                onSelected: (selected) {
                  switch (selected) {
                    case '明亮':
                      AdaptiveTheme.of(context).setLight();
                      break;
                    case '暗黑':
                      AdaptiveTheme.of(context).setDark();
                      break;
                    case '跟随系统':
                      AdaptiveTheme.of(context).setSystem();
                      break;
                  }
                },
              );
            },
          ),

          const SizedBox(height: 8),

          // 语言设置
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return SettingItem(
                icon: Icons.language,
                title: '切换语言',
                subtitle: languageProvider.language,
                options: const ['中文', 'English', '日本語', '한국어'],
                isArrow: true,
                onSelected: (selected) {
                  languageProvider.setLanguage(selected);
                },
              );
            },
          ),

          const SizedBox(height: 8),

          // 涨跌颜色设置
          Consumer<ChangeColorProvider>(
            builder: (context, colorProvider, child) {
              return SettingItem(
                icon: Icons.show_chart,
                title: '涨跌颜色',
                subtitle: colorProvider.subtitle,
                options: const ['涨绿跌红', '涨红跌绿'],
                isArrow: true,
                onSelected: (selected) {
                  if (selected == '涨红跌绿' &&
                      colorProvider.mode == ChangeColorMode.greenUpRedDown) {
                    colorProvider.toggleMode();
                  } else if (selected == '涨绿跌红' &&
                      colorProvider.mode == ChangeColorMode.redUpGreenDown) {
                    colorProvider.toggleMode();
                  }
                },
              );
            },
          ),

          const SizedBox(height: 8),

          // 意见反馈
          SettingItem(
            icon: Icons.feedback,
            title: '意见反馈',
            isArrow: true,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('意见反馈功能待实现')),
              );
            },
          ),

          const SizedBox(height: 8),

          // 注销账号
          SettingItem(
            icon: Icons.logout,
            title: '注销账号',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('确认注销'),
                  content: const Text('确定要注销当前账号吗？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('账号注销功能待实现')),
                        );
                      },
                      child: const Text('确认'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
