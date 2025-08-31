import 'package:flutter/material.dart';
import 'header/header.dart';
import 'components/function_bar.dart';
import 'components/post_list.dart';
import 'components/post_item_model.dart';
import '../../network/Get/models/news_page/news.dart';
import '../../network/Get/services/news_page/news.dart';
import '../../localization/i18n/lang.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int _selectedFunctionIndex = 0;
  int _selectedTabIndex = 0; // ForumHeader 当前选中的 tab
  late Future<List<News>> _futureMessages;

  @override
  void initState() {
    super.initState();
    // 调用后端接口获取数据
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

  /// 占位页
  Widget _buildEmpty(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
