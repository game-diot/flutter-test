import 'package:flutter/material.dart';
import '../../detail_page/detail_page.dart';
class ForumPostBlock extends StatelessWidget {
  final IconData tagIcon;
  final String title;
  final String author;
  final String content;
  final int likes;
  final int comments;
  final int? rank; // 排行榜编号，可选

  const ForumPostBlock({
    Key? key,
    required this.tagIcon,
    required this.title,
    required this.author,
    required this.content,
    this.likes = 0,
    this.comments = 0,
    this.rank,
  }) : super(key: key);
Color getRankColor(int rank) {
  switch (rank) {
    case 1:
      return Colors.red;
    case 2:
      return Colors.deepOrange;
    case 3:
      return Colors.orange;
    case 4:
      return Colors.blue;
    default:
      return Colors.grey;
  }
}



  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(
          title: title,
          avatarUrl: 'https://example.com/user.jpg', // 可动态
          nickname: author,
          time: DateTime.now().toString(), // 可动态
          content: content,
          starCount: likes, // 也可以自定义
          likeCount: likes,
          commentCount: comments,
        ),
      ),
    );
  },

    child: Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4)],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧标签
              Column(
                children: [
                  Icon(tagIcon, size: 24, color: Color.fromRGBO(237, 176, 35, 1)),
                ],
              ),
              SizedBox(width: 12),
              // 右侧内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    // 作者信息
                    Row(
                      children: [
                        Icon(Icons.account_circle, size: 16, color: Color.fromRGBO(237, 176, 35, 1)),
                        SizedBox(width: 4),
                        Text(
                          author,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    // 内容摘要
                    Text(
                      content,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    // 点赞与评论
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('$likes', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(width: 16),
                        Icon(Icons.comment, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('$comments', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 排行榜徽章
       // 使用
if (rank != null)
  Positioned(
    right: 24,
    top: 4,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: getRankColor(rank!), // 根据排名设置颜色
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$rank',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  // 其他子元素...
  ],
    )
);
}
}
