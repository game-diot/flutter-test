import 'package:flutter/material.dart';
import 'header/header.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Header
        SettingPageHeader(),

        SizedBox(height: 20),

        // 中部两按钮：我的帖子 / 我的点赞
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            children: [
              Expanded(child: _buildStatButton('我的帖子', '12')),
              SizedBox(width: 16),
              Expanded(child: _buildStatButton('我的点赞', '34')),
            ],
          ),
        ),

        SizedBox(height: 20),

        // 广告图片
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage('assets/images/ad_banner.png'), // 替换为你的广告图片
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        SizedBox(height: 20),

        // 设置选项
        _buildSettingItem(Icons.language, '切换语言', '简体中文'),
        _buildSettingItem(Icons.light_mode, '主题', '白天'),
        _buildSettingItem(Icons.show_chart, '涨跌颜色', '', isArrow: true),
        _buildSettingItem(Icons.feedback, '意见反馈', ''),
        _buildSettingItem(Icons.logout, '注销账号', ''),
      ],
    );
  }

  // 横向按钮：我的帖子 / 我的点赞
Widget _buildStatButton(String title, String count) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 数字
        Text(
          count,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        // 文字 + 箭头
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ],
    ),
  );
}


  // 单个设置项
  Widget _buildSettingItem(IconData icon, String title, String value, {bool isArrow = true}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
          title: Text(title),
          trailing: isArrow
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (value.isNotEmpty)
                      Text(value, style: TextStyle(color: Colors.grey[600])),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                )
              : (value.isNotEmpty ? Text(value) : null),
          onTap: () {},
        ),
        Divider(height: 1),
      ],
    );
  }
}
