import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _key = 'selected_language';

  String _language = "中文"; // 默认语言
  String get language => _language;

  LanguageProvider() {
    _loadLanguage(); // 初始化时加载缓存
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
    _saveLanguage(); // 保存选择
  }

  /// 保存到 SharedPreferences
  Future<void> _saveLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _language);
  }

  /// 从 SharedPreferences 加载
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(_key);
    if (lang != null && lang.isNotEmpty) {
      _language = lang;
      notifyListeners();
    }
  }
}
