import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'compression_service.dart';

class I18nService {
  static const String _baseUrl = 'https://us14-h5.yanshi.lol';
  static const String _cacheKeyPrefix = 'translations_';
  static const String _lastUpdatePrefix = 'last_update_';
  static const int _cacheExpireHours = 24; // 缓存24小时过期

  /// 加载翻译数据
  static Future<Map<String, String>?> loadTranslations(
    String languageCode,
  ) async {
    try {
      // 1. 先尝试从缓存加载
      final cachedData = await _loadFromCache(languageCode);
      if (cachedData != null && !(await _isCacheExpired(languageCode))) {
        print('从缓存加载翻译: $languageCode');
        return cachedData;
      }

      // 2. 从服务器加载
      print('从服务器加载翻译: $languageCode');
      final remoteData = await _loadFromServer(languageCode);

      if (remoteData != null) {
        // 3. 缓存到本地
        await _saveToCache(languageCode, remoteData);
        return remoteData;
      }

      // 4. 服务器加载失败，返回缓存数据（如果有）
      return cachedData;
    } catch (e) {
      print('加载翻译失败: $e');
      // 发生错误时，尝试返回缓存数据
      return await _loadFromCache(languageCode);
    }
  }

  /// 从服务器加载翻译数据
  static Future<Map<String, String>?> _loadFromServer(
    String languageCode,
  ) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/api/app-api/system/i18n/json',
      ).replace(queryParameters: {'typeCode': languageCode});

      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json, text/plain, */*',
              'Accept-Encoding': 'gzip, deflate, br, zstd',
              'Accept-Language': 'zh-CN,zh;q=0.9',
              'l-content-encoding': 'gzip',
              'language': languageCode,
              'User-Agent':
                  'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result['code'] == 0) {
          final data = result['data'];

          // 检查是否是压缩数据
          if (data is String &&
              CompressionService.isValidCompressedData(data)) {
            // 解压数据
            final decompressed = CompressionService.decompressGzipBase64(data);
            if (decompressed != null) {
              return _convertToStringMap(decompressed);
            }
          } else if (data is Map) {
            // 直接返回数据
            return _convertToStringMap(data);
          }
        }
      }

      return null;
    } catch (e) {
      print('服务器请求失败: $e');
      return null;
    }
  }

  /// 转换数据为String -> String格式
  static Map<String, String> _convertToStringMap(Map<dynamic, dynamic> data) {
    final result = <String, String>{};
    data.forEach((key, value) {
      if (key != null && value != null) {
        result[key.toString()] = value.toString();
      }
    });
    return result;
  }

  /// 从缓存加载翻译数据
  static Future<Map<String, String>?> _loadFromCache(
    String languageCode,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cacheKeyPrefix$languageCode';
      final cachedJson = prefs.getString(cacheKey);

      if (cachedJson != null) {
        final data = json.decode(cachedJson) as Map<String, dynamic>;
        return data.map((key, value) => MapEntry(key, value.toString()));
      }

      return null;
    } catch (e) {
      print('缓存加载失败: $e');
      return null;
    }
  }

  /// 保存翻译数据到缓存
  static Future<void> _saveToCache(
    String languageCode,
    Map<String, String> data,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cacheKeyPrefix$languageCode';
      final updateKey = '$_lastUpdatePrefix$languageCode';

      await prefs.setString(cacheKey, json.encode(data));
      await prefs.setInt(updateKey, DateTime.now().millisecondsSinceEpoch);

      print('翻译数据已缓存: $languageCode');
    } catch (e) {
      print('缓存保存失败: $e');
    }
  }

  /// 检查缓存是否过期
  static Future<bool> _isCacheExpired(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final updateKey = '$_lastUpdatePrefix$languageCode';
      final lastUpdate = prefs.getInt(updateKey);

      if (lastUpdate == null) return true;

      final now = DateTime.now().millisecondsSinceEpoch;
      final expireTime = lastUpdate + (_cacheExpireHours * 60 * 60 * 1000);

      return now > expireTime;
    } catch (e) {
      return true;
    }
  }

  /// 清除指定语言的缓存
  static Future<void> clearCache(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_cacheKeyPrefix$languageCode');
      await prefs.remove('$_lastUpdatePrefix$languageCode');
      print('已清除缓存: $languageCode');
    } catch (e) {
      print('清除缓存失败: $e');
    }
  }

  /// 清除所有翻译缓存
  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_cacheKeyPrefix) ||
            key.startsWith(_lastUpdatePrefix)) {
          await prefs.remove(key);
        }
      }

      print('已清除所有翻译缓存');
    } catch (e) {
      print('清除所有缓存失败: $e');
    }
  }

  /// 预加载翻译数据
  static Future<void> preloadTranslations(List<String> languageCodes) async {
    for (final code in languageCodes) {
      await loadTranslations(code);
    }
  }
}
