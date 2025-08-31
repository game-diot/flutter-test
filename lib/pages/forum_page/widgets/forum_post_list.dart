import 'package:flutter/material.dart';
import 'forum_post_block.dart';
import '../models/forum_post_item.dart';

class ForumPostList extends StatelessWidget {
  final List<ForumPostItem> posts;

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
