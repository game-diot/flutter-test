import 'package:flutter/material.dart';

class NewsHeader extends StatefulWidget {
  const NewsHeader({Key? key}) : super(key: key);

  @override
  State<NewsHeader> createState() => _NewsHeaderState();
}

class _NewsHeaderState extends State<NewsHeader> {
  int _selectedIndex = 0; // 默认选中第一个

  final List<String> _labels = ['热搜', '广场', '原创', 'NFT', '科普'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(237, 176, 35, 1), // 背景色
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索框
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '搜索新闻',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
          SizedBox(height: 20),

          // 五个文字按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_labels.length, (index) {
              bool isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      _labels[index],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 40,
                      height: 2,
                      color: isSelected ? Colors.black : Colors.transparent,
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
