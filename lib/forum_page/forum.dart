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
                  : const Color.fromRGBO(237, 176, 35, 1),
              child: ForumHeader(),
            ),
            const SizedBox(height: 10),

            /// 功能栏
            ForumFunctionBar(
              selectedIndex: _selectedFunctionIndex,
              onSelect: (i) => setState(() => _selectedFunctionIndex = i),
            ),
            const SizedBox(height: 10),

            /// 帖子列表
            const Expanded(
              child: SingleChildScrollView(child: ForumPostList()),
            ),
          ],
        ),
      ),
    );
  }
}
