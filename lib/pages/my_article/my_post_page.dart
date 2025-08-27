// pages/my_posts_page.dart
import 'package:flutter/material.dart';
import 'components/common_header.dart';
import 'components/article_card.dart';

class MyPostsPage extends StatelessWidget {
  const MyPostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 示例数据
    final postList = [
      {
        "title": "Flutter UIashdgjjasydg7iadhjk家哈是德国海粟对爱温度计卡死你不信你不名称不能寄回家啊都不说假话组件封装",
        "avatar": "https://i.pravatar.cc/150?img=2",
        "username": "张三",
        "content": "这是一篇关于Flut撒打算大撒打算大就尬死都尬舞i为渡鸦高度压缩记得挂上度过ter组件封装的帖子……",
        "likes": 23,
        "comments": 5,
      },
      {
        "title": "数据可视化设计思路",
        "avatar": "https://i.pravatar.cc/150?img=3",
        "username": "李四",
        "content": "你想做可视化平asfajkbzxhjcy7iawbhjbmzxncuiyauiywdbhjasdghjatyuayuiweuioqwghju111111台？这里有一些设计思路……",
        "likes": 18,
        "comments": 2,
      },
       {
        "title": "数据可视化设计思路",
        "avatar": "https://i.pravatar.cc/150?img=3",
        "username": "李四",
        "content": "你想做可视化平台？这里有一些设计思路……",
        "likes": 18,
        "comments": 2,
      },
       {
        "title": "数据可视化设计思路",
        "avatar": "https://i.pravatar.cc/150?img=3",
        "username": "李四",
        "content": "你想做可视化平台？这里有一些设计思路……",
        "likes": 18,
        "comments": 2,
      },
       {
        "title": "数据可视化设计思路",
        "avatar": "https://i.pravatar.cc/150?img=3",
        "username": "李四",
        "content": "你想做可视化平台？这里有一些设计思路……",
        "likes": 18,
        "comments": 2,
      },
       {
        "title": "数据可视化设计思路",
        "avatar": "https://i.pravatar.cc/150?img=3",
        "username": "李四",
        "content": "你想做可视化平台？这里有一些设计思路……",
        "likes": 18,
        "comments": 2,
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CommonHeader(title: "我的帖子"),
      ),
      body: ListView.builder(
        itemCount: postList.length,
        itemBuilder: (context, index) {
          final post = postList[index];
          return ArticleCard(
            title: post['title'] as String,
            avatarUrl: post['avatar'] as String,
            username: post['username'] as String,
            content: post['content'] as String,
            likes: post['likes'] as int,
            comments: post['comments'] as int,
            onMore: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent, // 透明背景，让蒙版可见
                isScrollControlled: true, // 可以自适应高度
                builder: (context) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context); // 点击蒙版关闭
                    },
                    child: Container(
                      color: Colors.black54, // 暗色蒙版
                      child: GestureDetector(
                        onTap: () {}, // 阻止点击内容块时触发关闭
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 第一层：更多操作标题 + 关闭icon
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "更多操作",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context); // 点击叉号关闭
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // 第二层：编辑按钮
                                ListTile(
                                  leading: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  title: const Text(
                                    "编辑",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // TODO: 执行编辑操作
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("点击了编辑")),
                                    );
                                  },
                                ),

                                // 第三层：删除按钮
                                ListTile(
                                  leading: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  title: const Text(
                                    "删除",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // TODO: 执行删除操作
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("点击了删除")),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
