import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../localization/lang.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _keyLanguageCode = 'selected_language_code';
  static const String _keyLanguageName = 'selected_language_name';

  String _language = "中文";
  String _code = "zh";
  bool _isLoading = false;
  String? _error;

  // Getters
  String get language => _language;
  String get currentCode => _code;
  bool get isLoading => _isLoading;
  String? get error => _error;

  LanguageProvider() {
    _loadLanguage();
  }

  /// 设置语言（带远程翻译加载）
  Future<void> setLanguage(String code, String lang) async {
    if (_code == code) {
      return; // 相同语言不需要重新加载
    }

    _setLoading(true);
    _clearError();

    try {
      print('开始切换语言: $lang ($code)');
      
      // 1. 立即更新UI显示的语言信息
      _language = lang;
      _code = code;
      notifyListeners();
      
      // 2. 保存语言选择到本地
      await _saveLanguage();
      
      // 3. 加载远程翻译数据
      final success = await Lang.loadRemoteTranslations(code);
      
      if (success) {
        print('翻译包加载成功: $lang');
      } else {
        print('翻译包加载失败，使用默认翻译: $lang');
        _setError('翻译包加载失败，使用默认翻译');
      }
      
    } catch (e) {
      print('语言切换失败: $e');
      _setError('语言切换失败: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// 静默加载翻译（不显示loading）
  Future<void> loadTranslationsQuietly(String code) async {
    try {
      await Lang.loadRemoteTranslations(code);
      print('静默加载翻译完成: $code');
    } catch (e) {
      print('静默加载翻译失败: $e');
    }
  }

  /// 预加载常用语言的翻译
  Future<void> preloadCommonLanguages() async {
    final commonLanguages = ['zh', 'en', 'pt', 'es', 'fr', 'de', 'ja', 'ko'];
    
    _setLoading(true);
    try {
      await Lang.preloadLanguages(commonLanguages);
      print('常用语言预加载完成');
    } catch (e) {
      print('预加载失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 保存语言设置到本地
  Future<void> _saveLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLanguageCode, _code);
      await prefs.setString(_keyLanguageName, _language);
      print('语言设置已保存: $_language ($_code)');
    } catch (e) {
      print('保存语言设置失败: $e');
    }
  }

  /// 从本地加载语言设置
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_keyLanguageCode);
      final savedName = prefs.getString(_keyLanguageName);
      
      if (savedCode != null && savedCode.isNotEmpty) {
        _code = savedCode;
        _language = savedName ?? _getLanguageDisplayName(savedCode);
        
        print('从本地加载语言设置: $_language ($_code)');
        
        // 异步加载翻译数据（不阻塞UI）
        _loadTranslationsInBackground();
        
        notifyListeners();
      }
    } catch (e) {
      print('加载语言设置失败: $e');
    }
  }

  /// 后台加载翻译数据
  void _loadTranslationsInBackground() async {
    try {
      await Lang.loadRemoteTranslations(_code);
      notifyListeners(); // 翻译加载完成后刷新UI
    } catch (e) {
      print('后台加载翻译失败: $e');
    }
  }

  /// 获取语言显示名称
  String _getLanguageDisplayName(String code) {
    final names = {
      'zh': '中文',
      'en': 'English',
      'pt': 'Português',
      'es': 'Español',
      'fr': 'Français',
      'de': 'Deutsch',
      'ja': '日本語',
      'ko': '한국어',
      'ru': 'Русский',
      'ar': 'العربية',
    };
    return names[code] ?? code.toUpperCase();
  }

  /// 设置加载状态
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// 设置错误信息
  void _setError(String? error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  /// 清除错误信息
  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  /// 重试加载翻译
  Future<void> retryLoadTranslations() async {
    await setLanguage(_code, _language);
  }

  /// 清除翻译缓存
  Future<void> clearTranslationCache([String? languageCode]) async {
    _setLoading(true);
    try {
      if (languageCode != null) {
        await Lang.clearCache(languageCode);
        print('已清除 $languageCode 的翻译缓存');
      } else {
        await Lang.clearAllCache();
        print('已清除所有翻译缓存');
      }
    } catch (e) {
      print('清除缓存失败: $e');
      _setError('清除缓存失败');
    } finally {
      _setLoading(false);
    }
  }

  /// 重置语言设置
  Future<void> resetLanguage() async {
    await setLanguage('zh', '中文');
  }

  /// 获取翻译统计信息
  Map<String, int> getTranslationStats() {
    return Lang.getTranslationStats();
  }

  /// 调试信息
  void debugPrint() {
    print('=== LanguageProvider Debug Info ===');
    print('Current Language: $_language ($_code)');
    print('Is Loading: $_isLoading');
    print('Error: $_error');
    Lang.debugPrintStats();
    print('===================================');
  }

  /// 检查是否有翻译数据
  bool hasTranslations([String? languageCode]) {
    final code = languageCode ?? _code;
    final translations = Lang.getTranslations(code);
    return translations.isNotEmpty;
  }

  /// 获取支持的语言列表
  List<String> getSupportedLanguages() {
    return Lang.getSupportedLanguages();
  }
}