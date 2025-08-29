import 'package:flutter/material.dart';
import '../home_page/container/data_section/models/combined_coin_data.dart';
import 'widgets/top_tab_bar.dart';
import 'widgets/header_info.dart';
import 'widgets/left_panel.dart';
import 'widgets/right_panel.dart';
import 'widgets/bottom_tab_content.dart';

class SocketBindPage extends StatefulWidget {
  final CombinedCoinData coin;
  const SocketBindPage({Key? key, required this.coin}) : super(key: key);

  @override
  State<SocketBindPage> createState() => _SocketBindPageState();
}

class _SocketBindPageState extends State<SocketBindPage> {
  int _selectedTopTab = 0;
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.coin.displayName + '详情页',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // 顶部Tab
          TopTabBarWithSwitch(
            selectedIndex: _selectedTopTab,
            tabs: ["永续合约", "极速合约"],
            onTabChanged: (index) => setState(() => _selectedTopTab = index),
            switchValue: _switchValue,
            onSwitchChanged: (val) => setState(() => _switchValue = val),
          ),

          // Header信息行
          HeaderInfo(
            coin: widget.coin,
            switchValue: _switchValue,
            onSwitchChanged: (val) => setState(() => _switchValue = val),
          ),

          // 上方主体左右分割区域
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(flex: 1, child: LeftPanel(coin: widget.coin)),

                Expanded(flex: 1, child: RightPanel(coin: widget.coin)),
              ],
            ),
          ),

          // 页面下方的新Tab内容组件
          SizedBox(
            height: 310, // 你可以根据需要调整高度
            child: BottomTabContent(),
          ),
        ],
      ),
    );
  }
}
