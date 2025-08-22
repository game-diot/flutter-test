import 'package:flutter/material.dart';

/// 涨跌颜色模式
enum ChangeColorMode {
  greenUpRedDown, // 默认：涨=绿，跌=红
  redUpGreenDown, // 反转：涨=红，跌=绿
}

class ChangeColorProvider extends ChangeNotifier {
  ChangeColorMode _mode = ChangeColorMode.greenUpRedDown;

  ChangeColorMode get mode => _mode;

  void toggleMode() {
    _mode = _mode == ChangeColorMode.greenUpRedDown
        ? ChangeColorMode.redUpGreenDown
        : ChangeColorMode.greenUpRedDown;
    notifyListeners();
  }

  String get subtitle =>
      _mode == ChangeColorMode.greenUpRedDown ? "涨绿跌红" : "涨红跌绿";
}
