import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 涨跌颜色模式
enum ChangeColorMode {
  greenUpRedDown, // 默认：涨=绿，跌=红
  redUpGreenDown, // 反转：涨=红，跌=绿
}

class ChangeColorProvider extends ChangeNotifier {
  static const String _key = 'change_color_mode';

  ChangeColorMode _mode = ChangeColorMode.greenUpRedDown;
  ChangeColorMode get mode => _mode;

  ChangeColorProvider() {
    _loadMode(); // 初始化时从本地读取
  }

  /// 直接选择模式
  void setMode(ChangeColorMode mode) {
    if (_mode != mode) {
      _mode = mode;
      notifyListeners();
      _saveMode();
    }
  }

  /// 获取 subtitle
  String get subtitle =>
      _mode == ChangeColorMode.greenUpRedDown ? "涨绿跌红" : "涨红跌绿";

  // 保存到 SharedPreferences
  Future<void> _saveMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, _mode.index); // 保存枚举索引
  }

  // 从 SharedPreferences 加载
  Future<void> _loadMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key);
    if (index != null && index >= 0 && index < ChangeColorMode.values.length) {
      _mode = ChangeColorMode.values[index];
      notifyListeners();
    }
  }
}
