import 'package:flutter/material.dart';

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
      color: Colors.white,
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),

            // 内容区域
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(content),
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
                    child: const Text("回复"),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
