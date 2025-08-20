import 'package:flutter/material.dart';

class SettingPageHeader extends StatelessWidget {
  const SettingPageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(237, 176, 35,1), // 统一背景色（深蓝色），可以改成你需要的颜色
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
                  backgroundImage: AssetImage('assets/avatar.png'),
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
                        color: Colors.white70, // 文本改成白色，更清晰
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
                _infoItem('收藏', '12'),
                SizedBox(width: 24),
                _infoItem('被点赞', '34'),
                SizedBox(width: 24),
                _infoItem('被评论', '56'),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(237, 176, 35, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.white, width: 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text('编辑资料',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white, // 数字文字也改成白色
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
