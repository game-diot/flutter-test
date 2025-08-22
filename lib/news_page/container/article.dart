import 'package:flutter/material.dart';
import '../components/article_model.dart';

class ArticleOverview extends StatelessWidget {
  final ArticleOverviewItem item;

  ArticleOverview({Key? key, required this.item}) : super(key: key);

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.grey.shade300,
            blurRadius: 4,
          )
        ],
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
                    fontWeight: FontWeight.bold,
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
            child: Image.asset(
              item.imageUrl,
              width: 100,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
