import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  // 用于保存用户输入的标题和正文内容
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 返回箭头
          onPressed: () {
            Navigator.pop(context); // 点击返回按钮时，返回上一页
          },
        ),
        title: Text('添加帖子'), // 页面标题
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 页面介绍
            Text(
              '在这里你可以创建新的帖子。请填写帖子标题和内容。',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20), // 空间间隔

            // 标题输入框
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '帖子标题',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20), // 空间间隔

            // 正文输入框
            TextField(
              controller: _contentController,
              maxLines: 10, // 设置最大行数，表示这是一个多行输入框
              decoration: InputDecoration(
                labelText: '帖子内容',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20), // 空间间隔

            // 发布按钮
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 在这里你可以处理发布逻辑，例如保存数据、提交到服务器等
                  String title = _titleController.text;
                  String content = _contentController.text;
                  // 例如输出标题和内容
                  print('标题: $title');
                  print('内容: $content');
                },
                child: Text('发布'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 按钮颜色
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
