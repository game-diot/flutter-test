// i18n.dart - 完整版
// 语言管理 + 本地翻译 + 远程加载 + 压缩/缓存 + 调试/统计

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// ----------------- 压缩/解压服务 -----------------
class CompressionService {
  static Map<String, dynamic>? decompressGzipBase64(String compressedData) {
    try {
      if (!_isValidBase64(compressedData)) return null;
      final bytes = base64.decode(compressedData);
      if (bytes.length < 2 || bytes[0] != 0x1f || bytes[1] != 0x8b) return null;
      final archive = GZipDecoder();
      final decompressed = archive.decodeBytes(bytes);
      final jsonString = utf8.decode(decompressed);
      final parsed = json.decode(jsonString);
      if (parsed is Map<String, dynamic>) return parsed;
    } catch (_) {}
    return null;
  }

  static String? compressToGzipBase64(Map<String, dynamic> data) {
    try {
      final jsonString = json.encode(data);
      final bytes = utf8.encode(jsonString);
      final archive = GZipEncoder();
      final compressed = archive.encode(bytes);
      return base64.encode(compressed);
    } catch (_) {
      return null;
    }
  }

  static bool isValidCompressedData(String data) {
    try {
      if (!_isValidBase64(data)) return false;
      final bytes = base64.decode(data);
      return bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b;
    } catch (_) {
      return false;
    }
  }

  static bool _isValidBase64(String str) {
    try {
      final base64Regex = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
      if (!base64Regex.hasMatch(str)) return false;
      if (str.length % 4 != 0) return false;
      base64.decode(str);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Map<String, dynamic>? tryDecompressVariants(String data) {
    var result = decompressGzipBase64(data);
    if (result != null) return result;
    final cleanData = data.replaceAll(RegExp(r'\s+'), '');
    result = decompressGzipBase64(cleanData);
    if (result != null) return result;
    try {
      final decoded = base64.decode(data);
      final jsonString = utf8.decode(decoded);
      final parsed = json.decode(jsonString);
      if (parsed is Map<String, dynamic>) return parsed;
    } catch (_) {}
    return null;
  }
}

/// ----------------- i18n 服务（远程+缓存） -----------------
class I18nService {
  static const String _baseUrl = 'https://us15-h5.yanshi.lol';
  static const String _cacheKeyPrefix = 'translations_';
  static const String _lastUpdatePrefix = 'last_update_';
  static const int _cacheExpireHours = 24;

  static Future<Map<String, String>?> loadTranslations(
    String languageCode,
  ) async {
    try {
      final cachedData = await _loadFromCache(languageCode);
      final isCacheExpired = await _isCacheExpired(languageCode);
      if (cachedData != null && !isCacheExpired) return cachedData;

      final remoteData = await _loadFromServer(languageCode);
      if (remoteData != null && remoteData.isNotEmpty) {
        await _saveToCache(languageCode, remoteData);
        return remoteData;
      }

      if (cachedData != null) return cachedData;
    } catch (_) {}
    return null;
  }

  static Future<Map<String, String>?> _loadFromServer(
    String languageCode,
  ) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/api/app-api/system/i18n/json',
      ).replace(queryParameters: {'typeCode': languageCode});
      final headers = {
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'zh-CN,zh;q=0.9',
        'language': languageCode,
        'User-Agent':
            'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148',
      };
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final contentEncoding = response.headers['content-encoding'];
        String responseBody = response.body;
        if (contentEncoding?.toLowerCase() == 'gzip') {
          final bytes = response.bodyBytes;
          final archive = GZipDecoder();
          responseBody = utf8.decode(archive.decodeBytes(bytes));
        }
        final result = json.decode(responseBody);
        if (result['code'] == 0) {
          final data = result['data'];
          if (data is String && data.isNotEmpty) {
            if (CompressionService.isValidCompressedData(data)) {
              var decompressed = CompressionService.decompressGzipBase64(data);
              if (decompressed == null) {
                decompressed = CompressionService.tryDecompressVariants(data);
              }
              if (decompressed != null)
                return _convertToStringMap(decompressed);
            } else {
              try {
                final decoded = base64.decode(data);
                final jsonString = utf8.decode(decoded);
                return _convertToStringMap(json.decode(jsonString));
              } catch (_) {
                return _convertToStringMap(json.decode(data));
              }
            }
          } else if (data is Map) {
            return _convertToStringMap(data);
          }
        }
      }
    } catch (_) {}
    return null;
  }

  static Map<String, String> _convertToStringMap(dynamic data) {
    if (data is! Map) return {};
    final result = <String, String>{};
    data.forEach((key, value) {
      if (key != null && value != null)
        result[key.toString()] = value.toString();
    });
    return result;
  }

  static Future<Map<String, String>?> _loadFromCache(
    String languageCode,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cacheKeyPrefix$languageCode';
    final cachedJson = prefs.getString(cacheKey);
    if (cachedJson != null) {
      final data = json.decode(cachedJson) as Map<String, dynamic>;
      return data.map((key, value) => MapEntry(key, value.toString()));
    }
    return null;
  }

  static Future<void> _saveToCache(
    String languageCode,
    Map<String, String> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cacheKeyPrefix$languageCode';
    final updateKey = '$_lastUpdatePrefix$languageCode';
    await prefs.setString(cacheKey, json.encode(data));
    await prefs.setInt(updateKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<bool> _isCacheExpired(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    final updateKey = '$_lastUpdatePrefix$languageCode';
    final lastUpdate = prefs.getInt(updateKey);
    if (lastUpdate == null) return true;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now > lastUpdate + (_cacheExpireHours * 60 * 60 * 1000);
  }

  static Future<void> clearCache(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_cacheKeyPrefix$languageCode');
    await prefs.remove('$_lastUpdatePrefix$languageCode');
  }

  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_cacheKeyPrefix) ||
          key.startsWith(_lastUpdatePrefix)) {
        await prefs.remove(key);
      }
    }
  }
}

/// ----------------- 本地默认翻译 -----------------
class LocalTranslations {
  static final Map<String, String> zh = {
    'login': '登录',
    'register': '注册',
    'password': '密码',
    'username': '用户名',
    'logout': '退出登录',
    'home': '首页',
    'settings': '设置',
  };

  static final Map<String, String> en = {
    'login': 'Login',
    'register': 'Register',
    'password': 'Password',
    'username': 'Username',
    'logout': 'Logout',
    'home': 'Home',
    'settings': 'Settings',
  };
}

/// ----------------- 国际化管理 -----------------
class Lang {
  static String currentLang = 'zh';
  static final Map<String, String> _defaultChineseTranslations =
      Map<String, String>.from(LocalTranslations.zh);

  static Map<String, Map<String, String>> _translations = {
    'zh': Map<String, String>.from(LocalTranslations.zh),
    'en': Map<String, String>.from(LocalTranslations.en),
  };

  static void _initDefaultChineseTranslations() {
    if (_defaultChineseTranslations.isEmpty) {
      _defaultChineseTranslations.addAll(_translations['zh']!);
    }
  }

  /// ----------------- 语言预加载 -----------------
  /// 预加载常用语言，远程加载并缓存到本地
  static Future<void> preloadLanguages(List<String> languages) async {
    for (final lang in languages) {
      // 已经有本地数据则跳过
      if (_translations.containsKey(lang) && _translations[lang]!.isNotEmpty)
        continue;

      final remoteTranslations = await I18nService.loadTranslations(lang);
      if (remoteTranslations != null) {
        mergeTranslations(lang, remoteTranslations);
      }
    }
  }

  static void resetToDefaultChinese() {
    _initDefaultChineseTranslations();
    currentLang = 'zh';
    _translations['zh'] = Map<String, String>.from(_defaultChineseTranslations);
  }

  static String t(String key, {Map<String, String>? params}) {
    _initDefaultChineseTranslations();
    String text =
        _translations[currentLang]?[key] ??
        _defaultChineseTranslations[key] ??
        _translations['zh']?[key] ??
        _translations['en']?[key] ??
        key;
    if (params != null) {
      params.forEach((k, v) => text = text.replaceAll('{$k}', v));
    }
    return text;
  }

  static void overrideTranslations(
    String langCode,
    Map<String, String> externalTranslations,
  ) {
    _translations.putIfAbsent(langCode, () => {});
    _translations[langCode]!.addAll(externalTranslations);
  }

  static void setLang(String langCode) {
    if (_translations.containsKey(langCode)) currentLang = langCode;
  }

  static void addTranslation(String key, Map<String, String> values) {
    values.forEach((lang, text) {
      _translations.putIfAbsent(lang, () => {});
      _translations[lang]![key] = text;
    });
  }

  static Future<bool> loadRemoteTranslations(String languageCode) async {
    final remoteTranslations = await I18nService.loadTranslations(languageCode);
    if (remoteTranslations != null) {
      mergeTranslations(languageCode, remoteTranslations);
      currentLang = languageCode;
      return true;
    }
    return false;
  }

  static void mergeTranslations(
    String languageCode,
    Map<String, String> newTranslations,
  ) {
    _translations.putIfAbsent(languageCode, () => {});
    _translations[languageCode]!.addAll(newTranslations);
  }

  static Map<String, String> getCurrentTranslations() =>
      _translations[currentLang] ?? {};
  static Map<String, String> getTranslations(String languageCode) =>
      _translations[languageCode] ?? {};
  static bool hasTranslation(String key, [String? languageCode]) =>
      _translations[languageCode ?? currentLang]?.containsKey(key) ?? false;

  /// ----------------- 缓存操作 -----------------
  static Future<void> clearCache(String languageCode) async =>
      await I18nService.clearCache(languageCode);
  static Future<void> clearAllCache() async =>
      await I18nService.clearAllCache();

  /// ----------------- 调试与统计 -----------------
  static Map<String, int> getTranslationStats() {
    final stats = <String, int>{};
    _translations.forEach((lang, map) {
      stats[lang] = map.length;
    });
    return stats;
  }

  static void debugPrintStats() {
    final stats = getTranslationStats();
    stats.forEach((lang, count) {
      print('[Lang] $lang: $count keys');
    });
  }

  static bool validateTranslations() {
    bool valid = true;
    _translations.forEach((lang, map) {
      map.forEach((key, value) {
        if (value.isEmpty) {
          print('[Lang] Warning: empty value for key "$key" in "$lang"');
          valid = false;
        }
      });
    });
    return valid;
  }

  static bool hasValidTranslations(String languageCode) {
    final map = _translations[languageCode];
    if (map == null || map.isEmpty) return false;
    return !map.values.any((v) => v.isEmpty);
  }

  static List<String> getSupportedLanguages() => _translations.keys.toList();
}
