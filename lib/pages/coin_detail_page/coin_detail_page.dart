import 'package:flutter/material.dart';
import '../home_page/container/data_section/models/combined_coin_data.dart';
import 'models/model.dart'; // CoinDetail 模型
import 'widgets/top_tab_bar.dart';
import 'widgets/header_info.dart';
import 'widgets/left_panel.dart';
import 'widgets/right_panel.dart';
import 'widgets/bottom_tab_content.dart';
import 'services/api_service.dart';
import 'socket/controller.dart';
import 'services/api_service.dart';

class SocketBindPage extends StatefulWidget {
  final CombinedCoinData coin;
  const SocketBindPage({Key? key, required this.coin}) : super(key: key);

  @override
  State<SocketBindPage> createState() => _SocketBindPageState();
}

class _SocketBindPageState extends State<SocketBindPage> {
  int _selectedTopTab = 0;
  bool _switchValue = false;
  bool _isFullPosition = false;
  double _sliderStepPercent = 1.0;

  CoinDetail? _coinDetail;
  bool _isLoading = true;
  String? _errorMessage;
  final ApiService _apiService = ApiService();
  // 新增：深度数据 controller
  late DepthDataController _depthController;

  @override
  void initState() {
    super.initState();
    _fetchCoinDetail();

    // 初始化深度数据 controller
    _depthController = DepthDataController();
    _depthController.init(widget.coin.symbol);
    _depthController.addListener(_onDepthChange);
    _depthController.subscribe(widget.coin.symbol.replaceAll('_', '~'));
  }

  Future<void> _fetchCoinDetail() async {
    final symbol = widget.coin.symbol.replaceAll('_', '~');

    // 更新 loading 状态
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.fetchCoinDetail(symbol);

      if (mounted) {
        setState(() {
          _coinDetail = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "网络请求异常: $e";
        });
      }
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchCoinDetail, // 点击可以重试请求
            child: const Text("重试"),
          ),
        ],
      ),
    );
  }

  void _onDepthChange() {
    if (mounted) {
      setState(() {
        // 这里会触发 RightPanel 重建并使用最新深度数据
      });
    }
  }

  @override
  void dispose() {
    _depthController.removeListener(_onDepthChange);
    _depthController.unsubscribe(widget.coin.symbol.replaceAll('_', '~'));
    _depthController.dispose();
    super.dispose();
  }

  String _getDisplayName() {
    if (_coinDetail == null) return widget.coin.displayName; // 这里使用父组件数据

    String alias = _coinDetail!.alias; // 如果 CoinDetail 已经有数据，就用 API 返回的数据
    if (alias.endsWith('USDT')) {
      String base = alias.substring(0, alias.length - 4);
      return '$base/USDT';
    }
    return alias;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          _getDisplayName() + '详情页',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchCoinDetail,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorWidget()
          : _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    if (_coinDetail == null) {
      return const Center(
        child: Text('加载中或数据为空', style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      children: [
        TopTabBarWithSwitch(
          selectedIndex: _selectedTopTab,
          tabs: const ["永续合约", "极速合约"],
          onTabChanged: (index) => setState(() => _selectedTopTab = index),
        ),
        HeaderInfo(
          coin: widget.coin, // 父组件数据
          coinDetail: _coinDetail!, // API 或 socket 返回的详细数据
          exchangeDepth: _depthController.currentDepth, // socket 深度数据
          switchValue: _switchValue,
          onSwitchChanged: (val) => setState(() => _switchValue = val),
          isFullPosition: _isFullPosition,
          onFullPositionChanged: (val) => setState(() => _isFullPosition = val),
          sliderStepPercent: _sliderStepPercent,
          onSliderStepChanged: (val) =>
              setState(() => _sliderStepPercent = val),
        ),

        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: LeftPanel(
                  coinDetail: _coinDetail!,
                  sliderStepPercent: _sliderStepPercent,
                  isFullPosition: _isFullPosition,
                ),
              ),
              Expanded(
                flex: 1,
                child: RightPanel(
                  coinDetail: _coinDetail!,
                  exchangeDepth: _depthController.currentDepth, // 传入实时深度数据
                ),
              ),
            ],
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.30,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: BottomTabContent(scrollController: scrollController),
            );
          },
        ),
      ],
    );
  }
}
