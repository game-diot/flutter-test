import 'package:flutter/material.dart';

class NewsHeader extends StatefulWidget {
  final ValueChanged<int>? onTabSelected; // 新增回调

  const NewsHeader({Key? key, this.onTabSelected}) : super(key: key);

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

    final bgColor = isDark
        ? Color.fromARGB(255, 18, 18, 18)
        : Color.fromRGBO(237, 176, 35, 1);
    final textColor = isDark ? Color.fromRGBO(223, 229, 236, 1) : Colors.black;
    final searchBgColor = isDark ? Color(0xFF424242) : Colors.white;
    final searchTextColor = isDark ? Color(0xFF9D9D9D) : Colors.black87;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索框
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: searchBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(
                    Icons.search_rounded, // 圆角放大镜
                    color: Colors.grey,
                    size: 28, // 调大整体大小
                  ),
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: searchTextColor),
                    decoration: const InputDecoration(
                      hintText: '搜索新闻',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Tab 按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_labels.length, (index) {
              bool isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onTabSelected?.call(index); // 回调给 NewsPage
                },
                child: Column(
                  children: [
                    Text(
                      _labels[index],
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 15,
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
