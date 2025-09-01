import 'package:flutter/material.dart';
import 'detail_page_controller.dart';
import 'widgets/common_header.dart';
import 'widgets/detail_title.dart';
import 'widgets/detail_user_info.dart';
import 'widgets/detail_content.dart';
import 'widgets/detail_divider.dart';
import 'widgets/detail_bottom_bar.dart';
import 'widgets/comments/comment_section.dart';

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
    final controller = DetailPageController();

    return Scaffold(
      backgroundColor: controller.isDarkMode(context)
          ? Colors.grey[900]
          : Colors.white,
      bottomNavigationBar: DetailBottomBar(
        starCount: starCount,
        likeCount: likeCount,
        commentCount: commentCount,
        onCommentTap: () => controller.showCommentInput(context),
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
                    const CommentSection(),
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
