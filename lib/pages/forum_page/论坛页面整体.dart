import 'package:flutter/material.dart';
import '../../localization/i18n/lang.dart';
import '../detail_page/detail_page.dart';
import '../../network/Get/models/news_page/news.dart';
import '../../network/Get/services/news_page/news.dart';

/// 主页面
class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int _selectedFunctionIndex = 0;
  int _selectedTabIndex = 0; // 当前选中的 tab
  late Future<List<News>> _futureMessages;

  @override
  void initState() {
    super.initState();
    _futureMessages = NewsServices().fetchNewsMessages().then(
      (resp) => resp.list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromRGBO(18, 18, 18, 1)
                  : const Color.fromARGB(255, 255, 255, 255),
              child: ForumHeader(
                onTabSelected: (i) => setState(() => _selectedTabIndex = i),
              ),
            ),
            const SizedBox(height: 10),

            /// 根据 tab 显示内容
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTabIndex) {
      case 0:
        return Column(
          children: [
            ForumFunctionBar(
              selectedIndex: _selectedFunctionIndex,
              onSelect: (i) => setState(() => _selectedFunctionIndex = i),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<News>>(
                future: _futureMessages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${Lang.t("load_failed")}: ${snapshot.error}',
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmpty(Lang.t("no_data"));
                  }

                  final messages = snapshot.data!;
                  final posts = messages.map((msg) {
                    return ForumPostItem(
                      author: msg.authorityName,
                      title: msg.messageTitle,
                      content: msg.messageContent,
                      imageUrl: msg.imgUrl ?? msg.authorityAvatar,
                      createTime: msg.createTime,
                    );
                  }).toList();

                  return SingleChildScrollView(
                    child: ForumPostList(posts: posts),
                  );
                },
              ),
            ),
          ],
        );
      case 1:
        return _buildEmpty(Lang.t("no_blockchain_data"));
      case 2:
        return _buildEmpty(Lang.t("no_experience_data"));
      case 3:
        return _buildEmpty(Lang.t("no_complaint_data"));
      case 4:
        return _buildEmpty(Lang.t("no_tab_data"));
      default:
        return _buildEmpty(Lang.t("no_data"));
    }
  }

  Widget _buildEmpty(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

/// Header
class ForumHeader extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;

  const ForumHeader({super.key, this.onTabSelected});

  @override
  _ForumHeaderState createState() => _ForumHeaderState();
}

class _ForumHeaderState extends State<ForumHeader> {
  int _selectedIndex = 0;
  late List<String> _labels;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _labels = [
      Lang.t('hot_list'),
      Lang.t('blockchain'),
      Lang.t('experience'),
      Lang.t('complaint'),
      Lang.t('tab'),
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabSelected?.call(index);
  }

  Widget buildTextWithBorder(int index, bool isDark) {
    bool isSelected = _selectedIndex == index;
    Color textColor = isDark
        ? Colors.white.withOpacity(isSelected ? 1.0 : 0.7)
        : (isSelected
              ? const Color.fromRGBO(41, 46, 56, 1)
              : const Color.fromRGBO(46, 46, 46, 1));
    Color borderColor = const Color.fromARGB(255, 0, 0, 0);

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            _labels[index],
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 20,
            height: 2,
            color: isSelected ? borderColor : Colors.transparent,
            margin: const EdgeInsets.only(top: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final searchBg = isDark
        ? const Color.fromRGBO(66, 66, 66, 1)
        : const Color.fromRGBO(242, 242, 242, 1);
    final searchIconColor = Colors.grey;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: searchBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: searchIconColor),
                hintText: Lang.t("search_forum"),
                hintStyle: TextStyle(color: searchIconColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _labels.length,
              (i) => buildTextWithBorder(i, isDark),
            ),
          ),
        ),
      ],
    );
  }
}

/// 功能栏
class ForumFunctionBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ForumFunctionBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buildButton(String icon, String label) {
      return GestureDetector(
        onTap: () {}, // 可回调
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : Colors.white,
                border: Border.all(
                  color: const Color.fromRGBO(134, 144, 156, 0.4),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(icon, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color.fromRGBO(223, 229, 236, 1)
                    : Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildButton("assets/images/hot.png", Lang.t("today_hot")),
        buildButton("assets/images/week.png", Lang.t("weekly_must")),
        buildButton("assets/images/topic.png", Lang.t("hot_topics")),
        buildButton("assets/images/fake.png", Lang.t("fake_news")),
      ],
    );
  }
}

/// PostItem 数据模型
class ForumPostItem {
  final String title;
  final String author;
  final String content;
  final String imageUrl;
  final DateTime createTime;
  final int likes;
  final int comments;
  final int? rank;

  ForumPostItem({
    required this.title,
    required this.author,
    required this.content,
    required this.imageUrl,
    required this.createTime,
    this.likes = 0,
    this.comments = 0,
    this.rank,
  });
}

/// PostBlock UI
class ForumPostBlock extends StatelessWidget {
  final String title;
  final String author;
  final String content;
  final int likes;
  final int comments;
  final int? rank;

  const ForumPostBlock({
    Key? key,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;
    final titleColor = isDark
        ? const Color.fromRGBO(223, 229, 236, 1)
        : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.grey[600];
    final iconColor = const Color.fromRGBO(237, 176, 35, 1);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(
              title: title,
              avatarUrl: 'https://example.com/user.jpg',
              nickname: author,
              time: DateTime.now().toString(),
              content: content,
              starCount: likes,
              likeCount: likes,
              commentCount: comments,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 30,
                            color: iconColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            author,
                            style: TextStyle(
                              fontSize: 16,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        content,
                        style: TextStyle(fontSize: 12, color: subtitleColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '$likes',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            Lang.t('like'),
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '/',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$comments',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                          Text(
                            Lang.t('comment'),
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (rank != null)
            Positioned(
              left: 16,
              top: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 1.5,
                ),
                decoration: BoxDecoration(
                  color: getRankColor(rank!),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// PostList
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
