import 'package:flutter/material.dart';

class NewsHeader extends StatefulWidget {
  @override
  _NewsHeaderState createState() => _NewsHeaderState();
}

class _NewsHeaderState extends State<NewsHeader> {
  // 用于记录点击的文字，控制底部边框显示
  int _selectedIndex = -1; // -1 表示没有选中

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue, // 背景色
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索框
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white, // 输入框背景色为白色
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), // 放大镜图标
                hintText: '搜索新闻',
                border: InputBorder.none, // 取消默认边框
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
          SizedBox(height: 20), // 搜索框和文字之间的间距

          // 五个文字，点击后出现底部边框
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index; // 设置选中的文字
                  });
                },
                child: Column(
                  children: [
                    Text(
                      '文字${index + 1}',
                      style: TextStyle(
                        color: Colors.white, // 文字颜色
                        fontSize: 16,
                      ),
                    ),
                    // 底部边框
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 40,
                      height: 2,
                      color: _selectedIndex == index ? Colors.white : Colors.transparent,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
