import 'package:flutter/material.dart';
import '../../message_page/commons_page.dart';
import '../../message_page/likes_page.dart';

class SettingPageHeader extends StatelessWidget {
  const SettingPageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(81, 63, 41, 1), // 上方颜色
            Color.fromRGBO(54, 40, 24, 1), // 下方颜色
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // 上部
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                // 左侧头像
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=4',
                  ),
                ),
                SizedBox(width: 16),
                // 右侧账号信息
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1234564879@qq.com',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '无敌飞机',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // 下部
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // 收藏
                _infoItem(context, '收藏', '12'),
                SizedBox(width: 24),
                // 被点赞
                _infoItem(
                  context,
                  '被点赞',
                  '34',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LikedPage()),
                    );
                  },
                ),
                SizedBox(width: 24),
                // 被评论
                _infoItem(
                  context,
                  '被评论',
                  '56',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CommentedPage()),
                    );
                  },
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(81, 63, 41, 1),
                        Color.fromRGBO(54, 40, 24, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // 背景透明，显示渐变
                      shadowColor: Colors.transparent, // 去掉按钮默认阴影
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      '编辑资料',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
            SizedBox(height: 26),
        ],
      ),
    );
  }

  Widget _infoItem(
    BuildContext context,
    String title,
    String count, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
