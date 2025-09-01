import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'compression_service.dart';

class I18nService {
  static const _baseUrl = 'https://us14-h5.yanshi.lol';
  static const _cacheKeyPrefix = 'translations_';
  static const _lastUpdatePrefix = 'last_update_';
  static const _cacheExpireHours = 24;

  static Future<Map<String, String>?> loadTranslations(
    String languageCode,
  ) async {
    try {
      final cached = await _loadFromCache(languageCode);
      if (cached != null && !await _isCacheExpired(languageCode)) return cached;

      final remote = await _loadFromServer(languageCode);
      if (remote != null) {
        await _saveToCache(languageCode, remote);
        return remote;
      }

      return cached;
    } catch (_) {
      return null;
    }
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
        'language': languageCode,
      };
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data is String) {
          if (CompressionService.isValidCompressedData(data)) {
            final decompressed = CompressionService.tryDecompressVariants(data);
            if (decompressed != null)
              return decompressed.map(
                (k, v) => MapEntry(k.toString(), v.toString()),
              );
          } else {
            final decoded = json.decode(data);
            return decoded.map((k, v) => MapEntry(k.toString(), v.toString()));
          }
        } else if (data is Map) {
          return data.map((k, v) => MapEntry(k.toString(), v.toString()));
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<Map<String, String>?> _loadFromCache(
    String languageCode,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('$_cacheKeyPrefix$languageCode');
    if (jsonStr == null) return null;
    final map = json.decode(jsonStr) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k.toString(), v.toString()));
  }

  static Future<void> _saveToCache(
    String languageCode,
    Map<String, String> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_cacheKeyPrefix$languageCode', json.encode(data));
    await prefs.setInt(
      '$_lastUpdatePrefix$languageCode',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static Future<bool> _isCacheExpired(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getInt('$_lastUpdatePrefix$languageCode');
    if (last == null) return true;
    return DateTime.now().millisecondsSinceEpoch >
        last + (_cacheExpireHours * 3600 * 1000);
  }

  static Future<void> clearCache(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_cacheKeyPrefix$languageCode');
    await prefs.remove('$_lastUpdatePrefix$languageCode');
  }

  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys()) {
      if (key.startsWith(_cacheKeyPrefix) ||
          key.startsWith(_lastUpdatePrefix)) {
        await prefs.remove(key);
      }
    }
  }
}
