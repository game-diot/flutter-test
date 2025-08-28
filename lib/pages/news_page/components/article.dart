import 'package:flutter/material.dart';
import 'article_model.dart';

class ArticleOverview extends StatelessWidget {
  final ArticleOverviewItem item;

  ArticleOverview({Key? key, required this.item}) : super(key: key);

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // 判断主题
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 根据主题设置颜色
    final backgroundColor = isDark ? Colors.grey[850] : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black;
    final dateColor = isDark ? Colors.white70 : Colors.grey[600];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // 左侧文字
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _formatDate(item.publishDate),
                  style: TextStyle(fontSize: 12, color: dateColor),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          // 右侧图片
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.imageUrl.startsWith('http')
                ? Image.network(
                    item.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    item.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    );
  }
}
