import 'package:flutter/material.dart';

class NewsHeader extends StatefulWidget {
  const NewsHeader({Key? key}) : super(key: key);

  @override
  State<NewsHeader> createState() => _NewsHeaderState();
}

class _NewsHeaderState extends State<NewsHeader> {
  int _selectedIndex = 0;
  final List<String> _labels = ['热搜', '广场', '原创', 'NFT', '科普'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 根据主题设置颜色
    final bgColor = isDark ? Colors.grey[900] : Color.fromRGBO(237, 176, 35, 1);
    final textColor = isDark ? Color.fromRGBO(223, 229, 236, 1) : Colors.black;
    final searchBgColor = isDark ? Color(0xFFF2F2F2) : Colors.white; // 修改点
    final searchTextColor = isDark ? Colors.black87 : Colors.black87;
    final iconColor = isDark ? Colors.black54 : Colors.grey;

    return Container(
      color: bgColor,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索框
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: searchBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              style: TextStyle(color: searchTextColor),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: iconColor),
                hintText: '搜索新闻',
                hintStyle: TextStyle(color: iconColor),
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
                        color: textColor,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 40,
                      height: 2,
                      color: isSelected ? textColor : Colors.transparent,
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
