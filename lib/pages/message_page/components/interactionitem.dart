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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧头像
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 12),

            // 中间内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用户名
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 行为
                  Text(
                    actionText,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 内容
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 10,),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      content,
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 时间 + 回复按钮（可选）
                  Row(
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 12,
                        ),
                      ),
                      if (isComment) ...[
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            // 回复逻辑
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(40, 24),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "回复",
                            style: TextStyle(color: AppColors.accent(context)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // 右侧点赞
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 20,
                  color: AppColors.textSecondary(context),
                ),
                if (likeCount != null)
                  Text(
                    likeCount.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
