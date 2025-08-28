import 'package:flutter/material.dart';
import '../container/forumpostblock.dart';

class ForumPostList extends StatelessWidget {
  const ForumPostList({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        "title": "区块链最新动sadhsaiudiasudiuasdh u哈是对啊谁都会阿丝素丢啊是对哈电话现在看见进口8u态",
        "author": "张三",
        "content": "今天区块链又有新的发展趋势，需要关注市场变化啊是的哈是基督教啊我也刚到家啊好想抱回家啊数据个打火机低级趣味哈佛高大上的古和研究",
        "likes": 12,
        "comments": 3,
      },
      {
        "title": "区块链最新动态",
        "author": "张三",
        "content": "今天区块链又有新的发展趋势，需要撒打算大S大哭规划与啊DGU健康v阿萨和v很尬死的剧把手给大哥好像很高关注市场变化...",
        "likes": 12,
        "comments": 3,
      },
      {
        "title": "区块链最新动态",
        "author": "张三",
        "content": "今天区块链撒的女u同一个几乎要回家贵阳环境与规划艰苦附近有v换衣服又有新的发展趋势，需要关注市场变化...",
        "likes": 12,
        "comments": 3,
      },
      {
        "title": "区块链最新动态",
        "author": "张三",
        "content": "今天区块链又有新的发展趋势，需要关注市场变化...",
        "likes": 12,
        "comments": 3,
      },
      {
        "title": "区块链最新动态",
        "author": "张三",
        "content": "今天区块链又有新的发展趋势，需要关注市场变化...",
        "likes": 12,
        "comments": 3,
      },
      {
        "title": "心得分享：Flutter布局经验",
        "author": "李四",
        "content": "在实际开发中，使用Row+Column可以更好地处理复杂布局...",
        "likes": 8,
        "comments": 2,
      },
    ];

    return Column(
      children: List.generate(posts.length, (i) {
        final post = posts[i];
        return ForumPostBlock(
          title: post["title"] as String,
          author: post["author"] as String,
          content: post["content"] as String,
          likes: post["likes"] as int,
          comments: post["comments"] as int,
          rank: i + 1,
        );
      }),
    );
  }
}
