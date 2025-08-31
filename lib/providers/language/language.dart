import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../localization/i18n/lang.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _keyLanguageCode = 'selected_language_code';
  static const String _keyLanguageName = 'selected_language_name';

  // 🔹 新增缓存 key
  static const String _keyLanguageList = 'cached_language_list';
  static const String _keyLanguageListTimestamp =
      'cached_language_list_timestamp';
  static const String _keyRemoteTranslations = 'cached_remote_translations';
  static const String _keyRemoteTranslationsTimestamp =
      'cached_remote_translations_timestamp';

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
    print('=== LanguageProvider 初始化 ===');
    _loadLanguage();
  }

  /// 设置语言（带远程翻译加载）
  Future<void> setLanguage(String code, String lang) async {
    print('=== LanguageProvider.setLanguage 开始 ===');
    if (_code == code) {
      print('目标语言与当前语言相同，跳过切换');
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      _language = lang;
      _code = code;
      notifyListeners();

      await _saveLanguage();

      // 先尝试加载缓存的翻译
      final cached = await loadRemoteTranslationsCache(code);
      if (cached != null) {
        Lang.overrideTranslations(code, cached);
        print('✅ 使用缓存翻译: $code');
      }

      // 再请求远程翻译
      final success = await Lang.loadRemoteTranslations(code);
      if (success) {
        print('翻译包加载成功');
        // 保存到缓存
        await saveRemoteTranslationsCache(code, Lang.getTranslations(code));
      } else {
        print('翻译包加载失败');
        _setError('翻译包加载失败');
      }
    } catch (e, stackTrace) {
      print('语言切换异常: $e\n$stackTrace');
      _setError('语言切换失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  // ===============================
  // 🔹 语言列表缓存
  // ===============================
  Future<void> saveLanguageListCache(List<dynamic> languages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguageList, jsonEncode(languages));
    await prefs.setInt(
      _keyLanguageListTimestamp,
      DateTime.now().millisecondsSinceEpoch,
    );
    print("语言列表已缓存，共 ${languages.length} 个语言");
  }

  Future<List<dynamic>?> loadLanguageListCache({
    Duration maxAge = const Duration(days: 1),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = prefs.getString(_keyLanguageList);
    final timestamp = prefs.getInt(_keyLanguageListTimestamp);
    if (cacheData != null && timestamp != null) {
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) <= maxAge) {
        return jsonDecode(cacheData);
      }
    }
    return null;
  }

  // ===============================
  // 🔹 远程翻译缓存
  // ===============================
  Future<void> saveRemoteTranslationsCache(
    String code,
    Map<String, String> translations,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "$_keyRemoteTranslations\_$code";
    final keyTime = "$_keyRemoteTranslationsTimestamp\_$code";
    await prefs.setString(key, jsonEncode(translations));
    await prefs.setInt(keyTime, DateTime.now().millisecondsSinceEpoch);
    print("已缓存 $code 翻译，共 ${translations.length} 条");
  }

  Future<Map<String, String>?> loadRemoteTranslationsCache(
    String code, {
    Duration maxAge = const Duration(days: 1),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "$_keyRemoteTranslations\_$code";
    final keyTime = "$_keyRemoteTranslationsTimestamp\_$code";
    final cacheData = prefs.getString(key);
    final timestamp = prefs.getInt(keyTime);
    if (cacheData != null && timestamp != null) {
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) <= maxAge) {
        final raw = jsonDecode(cacheData) as Map<String, dynamic>;
        return raw.map((k, v) => MapEntry(k, v.toString()));
      }
    }
    return null;
  }

  /// 重置到默认中文
  Future<void> resetToDefaultChinese() async {
    print('=== 重置到默认中文 ===');

    _setLoading(true);
    _clearError();

    try {
      // 1. 重置Lang类到默认中文
      Lang.resetToDefaultChinese();

      // 2. 更新Provider状态
      _language = "中文";
      _code = "zh";

      // 3. 保存到本地
      await _saveLanguage();

      // 4. 通知UI更新
      notifyListeners();

      print('已重置到默认中文状态');
    } catch (e, stackTrace) {
      print('重置到默认中文失败: $e');
      print('异常堆栈: $stackTrace');
      _setError('重置失败: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// 静默加载翻译（不显示loading）
  Future<void> loadTranslationsQuietly(String code) async {
    print('静默加载翻译: $code');

    try {
      await Lang.loadRemoteTranslations(code);
      print('静默加载翻译完成: $code');

      // 静默加载完成后通知UI刷新
      notifyListeners();
    } catch (e) {
      print('静默加载翻译失败: $e');
    }
  }

  /// 预加载常用语言的翻译
  Future<void> preloadCommonLanguages() async {
    print('=== 预加载常用语言 ===');
    final commonLanguages = ['zh', 'en', 'pt', 'es', 'fr', 'de', 'ja', 'ko'];

    _setLoading(true);
    try {
      await Lang.preloadLanguages(commonLanguages);
      print('常用语言预加载完成');
    } catch (e) {
      print('预加载失败: $e');
      _setError('预加载失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 保存语言设置到本地
  Future<void> _saveLanguage() async {
    print('--- 保存语言设置到本地 ---');

    try {
      final prefs = await SharedPreferences.getInstance();
      final success1 = await prefs.setString(_keyLanguageCode, _code);
      final success2 = await prefs.setString(_keyLanguageName, _language);

      print('保存结果: 代码=$success1, 名称=$success2');
      print('保存内容: $_language ($_code)');

      if (success1 && success2) {
        print('语言设置保存成功');
      } else {
        print('语言设置保存部分失败');
      }
    } catch (e, stackTrace) {
      print('保存语言设置异常: $e');
      print('异常堆栈: $stackTrace');
    }
  }

  /// 从本地加载语言设置
  Future<void> _loadLanguage() async {
    print('--- 从本地加载语言设置 ---');

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_keyLanguageCode);
      final savedName = prefs.getString(_keyLanguageName);

      print('本地保存的语言代码: $savedCode');
      print('本地保存的语言名称: $savedName');

      if (savedCode != null && savedCode.isNotEmpty) {
        _code = savedCode;
        _language = savedName ?? _getLanguageDisplayName(savedCode);

        print('从本地加载语言设置成功: $_language ($_code)');

        // 异步加载翻译数据（不阻塞UI）
        _loadTranslationsInBackground();

        notifyListeners();
      } else {
        print('无本地语言设置，使用默认中文');

        // 确保默认中文翻译已初始化
        Lang.resetToDefaultChinese();
      }
    } catch (e, stackTrace) {
      print('加载语言设置异常: $e');
      print('异常堆栈: $stackTrace');

      // 异常时使用默认中文
      Lang.resetToDefaultChinese();
    }
  }

  /// 后台加载翻译数据
  void _loadTranslationsInBackground() async {
    print('后台加载翻译数据: $_code');

    try {
      final success = await Lang.loadRemoteTranslations(_code);
      print('后台翻译加载结果: $success');

      // 翻译加载完成后刷新UI
      notifyListeners();

      if (!success) {
        _setError('后台翻译加载失败，使用默认翻译');
      }
    } catch (e, stackTrace) {
      print('后台加载翻译异常: $e');
      print('异常堆栈: $stackTrace');
      _setError('后台翻译加载异常');
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
      'it': 'Italiano',
      'nl': 'Nederlands',
      'pl': 'Polski',
      'tr': 'Türkçe',
      'vi': 'Tiếng Việt',
      'th': 'ไทย',
      'hi': 'हिन्दी',
    };

    final displayName = names[code] ?? code.toUpperCase();
    print('语言代码 $code 的显示名称: $displayName');
    return displayName;
  }

  /// 设置加载状态
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      print('设置加载状态: $loading');
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// 设置错误信息
  void _setError(String? error) {
    if (_error != error) {
      print('设置错误信息: $error');
      _error = error;
      notifyListeners();
    }
  }

  /// 清除错误信息
  void _clearError() {
    if (_error != null) {
      print('清除错误信息');
      _error = null;
      notifyListeners();
    }
  }

  /// 重试加载翻译
  Future<void> retryLoadTranslations() async {
    print('重试加载翻译: $_code');
    await setLanguage(_code, _language);
  }

  /// 清除翻译缓存
  Future<void> clearTranslationCache([String? languageCode]) async {
    print('=== 清除翻译缓存 ===');

    _setLoading(true);
    try {
      if (languageCode != null) {
        await Lang.clearCache(languageCode);
        print('已清除 $languageCode 的翻译缓存');
      } else {
        await Lang.clearAllCache();
        print('已清除所有翻译缓存');
      }

      _clearError();
    } catch (e) {
      print('清除缓存异常: $e');
      _setError('清除缓存失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 重置语言设置
  Future<void> resetLanguage() async {
    print('重置语言设置');
    await resetToDefaultChinese();
  }

  /// 获取翻译统计信息
  Map<String, int> getTranslationStats() {
    final stats = Lang.getTranslationStats();
    print('翻译统计: $stats');
    return stats;
  }

  /// 调试信息
  void debugPrint() {
    print('================ LanguageProvider 调试信息 ================');
    print('当前语言: $_language ($_code)');
    print('加载状态: $_isLoading');
    print('错误信息: $_error');
    print('UI通知状态: ${hasListeners ? "有监听者" : "无监听者"}');

    // 调用Lang类的调试信息
    Lang.debugPrintStats();

    // 验证翻译完整性
    Lang.validateTranslations();

    print('======================================================');
  }

  /// 检查是否有翻译数据
  bool hasTranslations([String? languageCode]) {
    final code = languageCode ?? _code;
    final hasValid = Lang.hasValidTranslations(code);

    print('检查翻译数据: $code -> $hasValid');
    return hasValid;
  }

  /// 获取支持的语言列表
  List<String> getSupportedLanguages() {
    final supported = Lang.getSupportedLanguages();
    print('支持的语言: ${supported.join(", ")}');
    return supported;
  }

  /// 验证当前状态
  Map<String, dynamic> validateCurrentState() {
    print('验证当前Provider状态');

    final state = {
      'currentCode': _code,
      'currentLanguage': _language,
      'isLoading': _isLoading,
      'hasError': _error != null,
      'error': _error,
      'hasTranslations': hasTranslations(),
      'supportedLanguages': getSupportedLanguages(),
      'translationStats': getTranslationStats(),
    };

    print('Provider状态验证结果: $state');
    return state;
  }

  /// 强制刷新翻译
  Future<void> forceRefreshTranslations() async {
    print('=== 强制刷新翻译 ===');

    _setLoading(true);
    _clearError();

    try {
      // 清除当前语言缓存
      await Lang.clearCache(_code);

      // 重新加载翻译
      final success = await Lang.loadRemoteTranslations(_code);

      if (success) {
        print('强制刷新翻译成功');
      } else {
        print('强制刷新翻译失败，使用默认翻译');
        _setError('刷新失败，使用默认翻译');
      }

      notifyListeners();
    } catch (e, stackTrace) {
      print('强制刷新翻译异常: $e');
      print('异常堆栈: $stackTrace');
      _setError('刷新异常: $e');
    } finally {
      _setLoading(false);
    }
  }
}
