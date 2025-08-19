import 'package:flutter/material.dart';

class DetailCommentItem extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String content;
  final String time;
  final int likeCount;

  const DetailCommentItem({
    super.key,
    required this.avatarUrl,
    required this.username,
    required this.content,
    required this.time,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Avatar
          CircleAvatar(backgroundImage: NetworkImage(avatarUrl), radius: 20),
          const SizedBox(width: 10),

          // Middle Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(content),
                const SizedBox(height: 6),

                // 修改后的时间 + 按钮排布
                Row(
                  children: [
                    // 左侧时间固定位置
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    // 中间撑开空间
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 200,
                                color: Colors.white,
                                child: const Center(child: Text('回复评论')),
                              ),
                            );
                          },
                          child: const Text(
                            '点击展开评论',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right Like Icon
          Column(
            children: [
              Icon(Icons.thumb_up_alt_outlined, size: 20, color: Colors.grey),
              Text('$likeCount', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
