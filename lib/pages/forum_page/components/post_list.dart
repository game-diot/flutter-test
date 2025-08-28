import 'package:flutter/material.dart';
import '../container/forumpostblock.dart';
import 'post_item_model.dart';

class ForumPostList extends StatelessWidget {
  final List<ForumPostItem> posts; // 从父级传入

  const ForumPostList({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(posts.length, (i) {
        final post = posts[i];
        return ForumPostBlock(
          title: post.title,
          author: post.author,
          content: post.content,
          likes: post.likes,
          comments: post.comments,
          rank: post.rank ?? (i + 1),
        );
      }),
    );
  }
}
