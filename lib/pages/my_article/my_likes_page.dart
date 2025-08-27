import 'package:flutter/material.dart';
import 'components/common_header.dart';
import 'components/article_card.dart';

class MyLikesPage extends StatelessWidget {
  const MyLikesPage({Key? key}) : super(key: key);

  // 示例文章数据
  final List<Map<String, dynamic>> articles = const [
    {
      "title": "我点赞的第一篇文撒打算大为大撒打算大大为单位章",
      "avatarUrl": "https://i.pravatar.cc/150?img=2",
      "username": "王五",
      "content": "这里是文章内容摘要，超出部不回家睡啊与i在小吃街卡百花竞开岁哈收到回家就能看对哦啊思考角度讲卡速度和i分自动省略……",
      "likes": 120,
      "comments": 45,
    },
    {
      "title": "我点赞的第撒的从v哇啊被挖不完吧巴巴爸爸巴巴爸爸3啊但是是官方的防护服二篇文章",
      "avatarUrl": "https://i.pravatar.cc/150?img=3",
      "username": "李四",
      "content": "第二篇文章内容，这里有更多该说的是德国地方容光焕发的如果能够发挥发给他会觉得幸福如果河南登封人和事文字……",
      "likes": 56,
      "comments": 12,
    },
    {
      "title": "我点赞的第三篇文章",
      "avatarUrl": "https://i.pravatar.cc/150?img=4",
      "username": "张三",
      "content": "第三篇文章内容，这里是摘要……",
      "likes": 78,
      "comments": 34,
    },
    // 可继续添加更多文章
  ];

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

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black54,
            child: GestureDetector(
              onTap: () {},
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "更多操作",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildActionButton(
                              icon: Icons.favorite,
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
                              icon: Icons.chat_bubble_outline,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CommonHeader(title: "我的点赞"),
      ),
      body: ListView(
        children: articles
            .map(
              (article) => ArticleCard(
                title: article["title"],
                avatarUrl: article["avatarUrl"],
                username: article["username"],
                content: article["content"],
                likes: article["likes"],
                comments: article["comments"],
                onMore: () => _showMoreActions(context),
              ),
            )
            .toList(),
      ),
    );
  }
}
