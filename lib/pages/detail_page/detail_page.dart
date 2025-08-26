import 'package:flutter/material.dart';
import 'components/detail_title.dart';
import 'components/detail_user_info.dart';
import 'components/detail_content.dart';
import 'components/detail_divider_item.dart';
import 'components/detail_bottom_bar.dart';
import 'comment_section.dart';
import '../my_article/components/common_header.dart';
class DetailPage extends StatelessWidget {
  final String title;
  final String avatarUrl;
  final String nickname;
  final String time;
  final String content;
  final int starCount;
  final int likeCount;
  final int commentCount;

  const DetailPage({
    super.key,
    required this.title,
    required this.avatarUrl,
    required this.nickname,
    required this.time,
    required this.content,
    this.starCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      bottomNavigationBar: DetailBottomBar(
        starCount: starCount,
        likeCount: likeCount,
        commentCount: commentCount,
        onCommentTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              color: isDark ? Colors.grey[850] : Colors.white,
              child: Center(
                child: Text(
                  '评论输入框...',
                  style: TextStyle(
                      color: isDark ? Color.fromRGBO(223, 229, 236, 1) : Colors.black),
                ),
              ),
            ),
          );
        },
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CommonHeader(title: "文章详情"),
      ),
      body: SafeArea(
        child: Column(
          children: [
        
            DetailTitle(title: title),
            DetailUserInfo(
              avatarUrl: avatarUrl,
              nickname: nickname,
              time: time,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DetailContent(content: content),
                    const DetailDivider(),
                    CommentSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
