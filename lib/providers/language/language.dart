import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _language = "中文"; // 默认语言

  String get language => _language;

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }
}
