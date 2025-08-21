import 'package:flutter/material.dart';

class AppColors {
  /// 页面背景
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F5);

  /// 卡片背景
  static Color cardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : Colors.white;

  /// 主文本
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;

  /// 次级文本
  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[400]!
          : Colors.grey[700]!;

  /// 强调色（按钮/高亮）
  static Color accent(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
}

class InteractionItem extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String actionText;
  final String content;
  final String time;
  final bool isComment; // 决定是否显示“回复”
  final int? likeCount;

  const InteractionItem({
    Key? key,
    required this.avatarUrl,
    required this.username,
    required this.actionText,
    required this.content,
    required this.time,
    required this.isComment,
    this.likeCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: AppColors.cardBackground(context),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头像 + 用户名 + 动作描述
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "$username $actionText",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 内容区域
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                content,
                style: TextStyle(color: AppColors.textPrimary(context)),
              ),
            ),

            const SizedBox(height: 8),

            // 底部操作栏：可选“回复”按钮
            if (isComment)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // 回复逻辑
                    },
                    child: Text(
                      "回复",
                      style: TextStyle(color: AppColors.accent(context)),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
