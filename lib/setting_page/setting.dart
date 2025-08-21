import 'package:flutter/material.dart';
import 'header/header.dart';
import '../my_article/my_likes_page.dart';
import '../my_article/my_post_page.dart';
import 'components/Setting_item.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background, // 背景颜色适配主题
      body: ListView(
        children: [
          // Header
          const SettingPageHeader(),
          const SizedBox(height: 20),

          // 中部两按钮：我的帖子 / 我的点赞
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    '我的帖子',
                    '12',
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
                  child: _buildStatButton(
                    context,
                    '我的点赞',
                    '34',
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

          // 广告图片
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/ad_banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 设置选项
          _buildSettingItem(context, Icons.language, '切换语言', '简体中文', isArrow: true),
          _buildSettingItem(
            context,
            Icons.light_mode,
            '主题',
            '${Theme.of(context).brightness == Brightness.dark ? '暗黑' : '明亮'}',
            isArrow: true,
          ),
          _buildSettingItem(context, Icons.show_chart, '涨跌颜色', '', isArrow: true),
          _buildSettingItem(context, Icons.feedback, '意见反馈', '', isArrow: true),
          _buildSettingItem(context, Icons.logout, '注销账号', ''),
        ],
      ),
    );
  }

  // 横向按钮：我的帖子 / 我的点赞
  Widget _buildStatButton(
    BuildContext context,
    String title,
    String count, {
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface, // 背景颜色适配主题
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.4),
          width: 0.4,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 数字
              Text(
                count,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              // 标题 + 箭头
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.onSurface),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 单个设置项
  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    bool isArrow = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onSurface), // 图标颜色
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface, // 标题颜色
                  fontSize: 16,
                ),
              ),
            ),
            if (subtitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant, // 副标题颜色
                    fontSize: 14,
                  ),
                ),
              ),
            if (isArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant, // 箭头颜色
              ),
          ],
        ),
      ),
    );
  }
}
