import 'package:flutter/material.dart';
import 'components/detail_appbar.dart';
import 'components/detail_title.dart';
import 'components/detail_user_info.dart';
import 'components/detail_content.dart';
import 'components/detail_divider_item.dart';
import 'components/detail_bottom_bar.dart';
import 'comment_section.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       bottomNavigationBar: DetailBottomBar(
        starCount: 12,
        likeCount: 34,
        commentCount: 56,
        onCommentTap: () {
          // 弹出底部输入框
          showModalBottomSheet(
            context: context,
            builder: (_) => Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: const Center(child: Text('评论输入框...')),
            ),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            DetailAppBar(onBack: () => Navigator.pop(context)),
            const DetailTitle(title: '如何实现Flutter组件化'),
            const DetailUserInfo(
              avatarUrl: 'https://example.com/user.jpg',
              nickname: '张三',
              time: '2025-08-19',
            ),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DetailContent(
                      content:
                          '本文将介绍如何在Flutter项目中进行组件化设计，提升代码复用性与可维护性...。。。。。。。。。。。。。。。。。',
                    ),
                    DetailDivider(),
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
