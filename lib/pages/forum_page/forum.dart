import 'package:flutter/material.dart';
import 'header/header.dart';
import 'components/function_bar.dart';
import 'components/post_list.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int _selectedFunctionIndex = 0;
  int _selectedTabIndex = 0; // ForumHeader 当前选中的 tab

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

  /// 根据 ForumHeader 的 tab 切换内容
  Widget _buildContent() {
    switch (_selectedTabIndex) {
      case 0: // 热榜（显示功能栏 + 帖子）
        return Column(
          children: [
            ForumFunctionBar(
              selectedIndex: _selectedFunctionIndex,
              onSelect: (i) => setState(() => _selectedFunctionIndex = i),
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: SingleChildScrollView(child: ForumPostList()),
            ),
          ],
        );
      case 1:
        return _buildEmpty("暂无区块链数据，请稍后查看");
      case 2:
        return _buildEmpty("暂无心得数据，请稍后查看");
      case 3:
        return _buildEmpty("暂无吐槽大会数据，请稍后查看");
      case 4:
        return _buildEmpty("暂无 Tab 数据，请稍后查看");
      default:
        return _buildEmpty("暂无数据");
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
