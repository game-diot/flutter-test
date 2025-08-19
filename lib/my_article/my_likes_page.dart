// pages/my_likes_page.dart
import 'package:flutter/material.dart';
import 'components/common_header.dart';
import 'components/article_card.dart';

class MyLikesPage extends StatelessWidget {
  const MyLikesPage({Key? key}) : super(key: key);


// -------------------------
// 可在同一个文件或者组件文件里定义
Widget _buildActionButton({
  required IconData icon,
  required String label,
  Color color = Colors.black,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    // 示例数据与上面类似
    return Scaffold(
      appBar: AppBar(
        title: Text('我的点赞'),
        // 使用系统默认的AppBar替代自定义的CommonHeader以解决类型不匹配问题
      ),
      body: ListView(
        children: [
          ArticleCard(
            title: "我点赞的第一篇文章",
            avatarUrl: "https://example.com/avatar1.jpg",
            username: "王五",
            content: "这里是文章内容摘要，超出部分自动省略……",
            likes: 120,
            comments: 45,
            onMore: () {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context), // 点击蒙版关闭
        child: Container(
          color: Colors.black54,
          child: GestureDetector(
            onTap: () {}, // 阻止点击内容块关闭
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 顶部标题 + 关闭按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "更多操作",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(height: 1, color: Colors.grey),

                    // 中间按钮：从左到右排列
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(
                            icon: Icons.thumb_down_alt_outlined,
                            label: "取消点赞",
                            color: Colors.red,
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("取消点赞")),
                              );
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.comment_outlined,
                            label: "评论",
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("点击评论")),
                              );
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.share_outlined,
                            label: "分享",
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("点击分享")),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
},

          ),
          // 更多 ArticleCard ...
        ],
      ),
    );
  }
}
