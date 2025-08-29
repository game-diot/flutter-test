import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'compression_service.dart';
import 'package:archive/archive.dart';

class I18nService {
  static const String _baseUrl = 'https://us14-h5.yanshi.lol';
  static const String _cacheKeyPrefix = 'translations_';
  static const String _lastUpdatePrefix = 'last_update_';
  static const int _cacheExpireHours = 24; // 缓存24小时过期

  /// 加载翻译数据
  static Future<Map<String, String>?> loadTranslations(
    String languageCode,
  ) async {
    print('=== I18nService.loadTranslations 开始 ===');
    print('目标语言: $languageCode');

    try {
      // 1. 先尝试从缓存加载
      print('步骤1: 尝试从缓存加载翻译');
      final cachedData = await _loadFromCache(languageCode);
      final isCacheExpired = await _isCacheExpired(languageCode);

      print('缓存数据存在: ${cachedData != null}');
      print('缓存是否过期: $isCacheExpired');

      if (cachedData != null && !isCacheExpired) {
        print('使用有效缓存数据，缓存条数: ${cachedData.length}');
        return cachedData;
      }

      // 2. 从服务器加载
      print('步骤2: 从服务器加载翻译');
      final remoteData = await _loadFromServer(languageCode);

      if (remoteData != null && remoteData.isNotEmpty) {
        print('服务器数据获取成功，条数: ${remoteData.length}');

        // 3. 缓存到本地
        print('步骤3: 缓存数据到本地');
        await _saveToCache(languageCode, remoteData);
        return remoteData;
      }

      // 4. 服务器加载失败，返回缓存数据（如果有）
      print('步骤4: 服务器加载失败，尝试使用过期缓存');
      if (cachedData != null) {
        print('使用过期缓存数据，条数: ${cachedData.length}');
        return cachedData;
      }

      print('无可用数据，返回null');
      return null;
    } catch (e, stackTrace) {
      print('加载翻译异常: $e');
      print('异常堆栈: $stackTrace');

      // 发生错误时，尝试返回缓存数据
      final cachedData = await _loadFromCache(languageCode);
      if (cachedData != null) {
        print('异常情况下使用缓存数据，条数: ${cachedData.length}');
        return cachedData;
      }

      return null;
    } finally {
      print('=== I18nService.loadTranslations 结束 ===');
    }
  }

  /// 从服务器加载翻译数据
  static Future<Map<String, String>?> _loadFromServer(
    String languageCode,
  ) async {
    print('--- _loadFromServer 开始 ---');
    print('请求语言: $languageCode');

    try {
      final uri = Uri.parse(
        '$_baseUrl/api/app-api/system/i18n/json',
      ).replace(queryParameters: {'typeCode': languageCode});

      print('请求URL: $uri');

      // 移除 Accept-Encoding 头，让 HTTP 客户端自动处理压缩
      final headers = {
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'zh-CN,zh;q=0.9',
        'language': languageCode,
        'User-Agent':
            'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148',
      };

      print('请求头: $headers');

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      print('响应状态码: ${response.statusCode}');
      print('响应头: ${response.headers}');

      if (response.statusCode == 200) {
        print('HTTP请求成功，开始解析响应');

        // 检查响应内容编码
        final contentEncoding = response.headers['content-encoding'];
        print('Content-Encoding: $contentEncoding');

        String responseBody;

        // HTTP 客户端通常会自动解压缩，直接获取响应体
        try {
          responseBody = response.body;
          print('响应体获取成功，长度: ${responseBody.length}');
        } catch (e) {
          print('无法获取响应体文本，尝试手动处理字节数据: $e');

          // 如果自动解压失败，尝试手动处理
          final bytes = response.bodyBytes;
          print('响应字节长度: ${bytes.length}');

          if (contentEncoding?.toLowerCase() == 'zstd') {
            print('检测到zstd压缩，但Flutter HTTP不支持自动解压');
            print('建议联系服务器管理员更改压缩格式为gzip');
            return null;
          } else if (contentEncoding?.toLowerCase() == 'gzip') {
            print('尝试手动解压gzip数据');
            try {
              final archive = GZipDecoder();
              final decompressed = archive.decodeBytes(bytes);

              responseBody = utf8.decode(decompressed);
              print('手动gzip解压成功');
            } catch (gzipError) {
              print('手动gzip解压失败: $gzipError');
              return null;
            }
          } else {
            print('尝试直接解码字节数据');
            try {
              responseBody = utf8.decode(bytes);
            } catch (decodeError) {
              print('UTF-8解码失败: $decodeError');
              return null;
            }
          }
        }

        // 解析JSON响应
        final result = json.decode(responseBody);
        print('JSON解析成功，结果类型: ${result.runtimeType}');
        print('响应code: ${result['code']}');

        if (result['code'] == 0) {
          final data = result['data'];
          print('API返回成功，数据类型: ${data.runtimeType}');

          if (data is String && data.isNotEmpty) {
            print('数据是字符串格式，长度: ${data.length}');
            print(
              '数据内容预览: ${data.substring(0, math.min(100, data.length))}...',
            );

            if (CompressionService.isValidCompressedData(data)) {
              print('检测到压缩数据，开始解压');

              // 尝试标准解压
              var decompressed = CompressionService.decompressGzipBase64(data);

              if (decompressed == null) {
                print('标准解压失败，尝试其他解压方法');
                decompressed = CompressionService.tryDecompressVariants(data);
              }

              if (decompressed != null) {
                print('解压成功，转换为字符串映射');
                return _convertToStringMap(decompressed);
              } else {
                print('所有解压方法均失败');
                return null;
              }
            } else {
              print('数据不是压缩格式，尝试直接解析');

              // 可能是直接的Base64编码JSON
              try {
                final decoded = base64.decode(data);
                final jsonString = utf8.decode(decoded);
                print('Base64解码成功，JSON字符串长度: ${jsonString.length}');

                final parsed = json.decode(jsonString);
                print('JSON解析成功');

                return _convertToStringMap(parsed);
              } catch (e) {
                print('Base64解析失败，尝试直接当作JSON解析: $e');

                try {
                  final parsed = json.decode(data);
                  return _convertToStringMap(parsed);
                } catch (e2) {
                  print('直接JSON解析也失败: $e2');
                  return null;
                }
              }
            }
          } else if (data is Map) {
            print('数据是Map格式，直接转换');
            return _convertToStringMap(data);
          } else {
            print('未知数据格式: ${data.runtimeType}');
            print('数据内容: $data');
            return null;
          }
        } else {
          print('API返回错误，code: ${result['code']}, msg: ${result['msg']}');
          return null;
        }
      } else {
        print('HTTP请求失败，状态码: ${response.statusCode}');
        print('错误响应: ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      print('服务器请求异常: $e');
      print('异常类型: ${e.runtimeType}');
      print('堆栈跟踪: $stackTrace');
      return null;
    } finally {
      print('--- _loadFromServer 结束 ---');
    }
  }

  /// 转换数据为String -> String格式
  static Map<String, String> _convertToStringMap(dynamic data) {
    print('转换数据为字符串映射，数据类型: ${data.runtimeType}');

    if (data is! Map) {
      print('数据不是Map类型，无法转换');
      return {};
    }

    final mapData = data;
    print('原始条数: ${mapData.length}');

    final result = <String, String>{};
    var convertedCount = 0;

    mapData.forEach((key, value) {
      if (key != null && value != null) {
        result[key.toString()] = value.toString();
        convertedCount++;
      } else {
        print('跳过空值: key=$key, value=$value');
      }
    });

    print('转换完成，有效条数: $convertedCount');
    return result;
  }

  /// 从缓存加载翻译数据
  static Future<Map<String, String>?> _loadFromCache(
    String languageCode,
  ) async {
    print('--- _loadFromCache 开始 ---');
    print('加载缓存: $languageCode');

    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cacheKeyPrefix$languageCode';
      final cachedJson = prefs.getString(cacheKey);

      print('缓存键: $cacheKey');
      print('缓存数据存在: ${cachedJson != null}');

      if (cachedJson != null) {
        print('缓存JSON长度: ${cachedJson.length}');

        final data = json.decode(cachedJson) as Map<String, dynamic>;
        final result = data.map(
          (key, value) => MapEntry(key, value.toString()),
        );

        print('缓存数据解析成功，条数: ${result.length}');
        return result;
      }

      print('无缓存数据');
      return null;
    } catch (e, stackTrace) {
      print('缓存加载异常: $e');
      print('异常堆栈: $stackTrace');
      return null;
    } finally {
      print('--- _loadFromCache 结束 ---');
    }
  }

  /// 保存翻译数据到缓存
  static Future<void> _saveToCache(
    String languageCode,
    Map<String, String> data,
  ) async {
    print('--- _saveToCache 开始 ---');
    print('保存缓存: $languageCode，数据条数: ${data.length}');

    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cacheKeyPrefix$languageCode';
      final updateKey = '$_lastUpdatePrefix$languageCode';
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      final jsonString = json.encode(data);
      print('JSON编码完成，字符串长度: ${jsonString.length}');

      final success1 = await prefs.setString(cacheKey, jsonString);
      final success2 = await prefs.setInt(updateKey, currentTime);

      print('缓存保存结果: 数据=$success1, 时间=$success2');
      print('保存时间戳: $currentTime');

      if (success1 && success2) {
        print('翻译数据缓存成功: $languageCode');
      } else {
        print('缓存保存部分失败');
      }
    } catch (e, stackTrace) {
      print('缓存保存异常: $e');
      print('异常堆栈: $stackTrace');
    } finally {
      print('--- _saveToCache 结束 ---');
    }
  }

  /// 检查缓存是否过期
  static Future<bool> _isCacheExpired(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final updateKey = '$_lastUpdatePrefix$languageCode';
      final lastUpdate = prefs.getInt(updateKey);

      print('检查缓存过期状态: $languageCode');
      print('上次更新时间戳: $lastUpdate');

      if (lastUpdate == null) {
        print('无更新时间戳，视为过期');
        return true;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      final expireTime = lastUpdate + (_cacheExpireHours * 60 * 60 * 1000);
      final isExpired = now > expireTime;

      print('当前时间戳: $now');
      print('过期时间戳: $expireTime');
      print('缓存是否过期: $isExpired');

      if (!isExpired) {
        final remainingHours = (expireTime - now) / (60 * 60 * 1000);
        print('缓存剩余有效时间: ${remainingHours.toStringAsFixed(1)} 小时');
      }

      return isExpired;
    } catch (e) {
      print('检查缓存过期异常: $e');
      return true;
    }
  }

  /// 清除指定语言的缓存
  static Future<void> clearCache(String languageCode) async {
    print('=== clearCache 开始 ===');
    print('清除缓存: $languageCode');

    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cacheKeyPrefix$languageCode';
      final updateKey = '$_lastUpdatePrefix$languageCode';

      final removed1 = await prefs.remove(cacheKey);
      final removed2 = await prefs.remove(updateKey);

      print('缓存清除结果: 数据=$removed1, 时间=$removed2');

      if (removed1 || removed2) {
        print('已清除缓存: $languageCode');
      } else {
        print('缓存可能不存在: $languageCode');
      }
    } catch (e) {
      print('清除缓存异常: $e');
    } finally {
      print('=== clearCache 结束 ---');
    }
  }

  /// 清除所有翻译缓存
  static Future<void> clearAllCache() async {
    print('=== clearAllCache 开始 ===');

    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      var removedCount = 0;

      print('共找到 ${keys.length} 个本地存储键');

      for (final key in keys) {
        if (key.startsWith(_cacheKeyPrefix) ||
            key.startsWith(_lastUpdatePrefix)) {
          final removed = await prefs.remove(key);
          if (removed) {
            removedCount++;
            print('已删除: $key');
          }
        }
      }

      print('共清除 $removedCount 个缓存项');
      print('已清除所有翻译缓存');
    } catch (e) {
      print('清除所有缓存异常: $e');
    } finally {
      print('=== clearAllCache 结束 ---');
    }
  }

  /// 预加载翻译数据
  static Future<void> preloadTranslations(List<String> languageCodes) async {
    print('=== preloadTranslations 开始 ===');
    print('预加载语言列表: ${languageCodes.join(", ")}');

    for (final code in languageCodes) {
      print('开始预加载: $code');
      final result = await loadTranslations(code);
      print('预加载结果 $code: ${result != null ? "成功(${result.length}条)" : "失败"}');
    }

    print('=== preloadTranslations 结束 ===');
  }

  /// 获取缓存统计信息
  static Future<Map<String, dynamic>> getCacheStats() async {
    print('获取缓存统计信息');

    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      final stats = <String, dynamic>{
        'totalKeys': keys.length,
        'translationCaches': <String, dynamic>{},
        'updateTimes': <String, int>{},
      };

      for (final key in keys) {
        if (key.startsWith(_cacheKeyPrefix)) {
          final lang = key.substring(_cacheKeyPrefix.length);
          final jsonData = prefs.getString(key);
          if (jsonData != null) {
            try {
              final data = json.decode(jsonData) as Map<String, dynamic>;
              stats['translationCaches'][lang] = {
                'count': data.length,
                'size': jsonData.length,
              };
            } catch (e) {
              print('解析缓存统计失败: $lang, $e');
            }
          }
        } else if (key.startsWith(_lastUpdatePrefix)) {
          final lang = key.substring(_lastUpdatePrefix.length);
          final timestamp = prefs.getInt(key);
          if (timestamp != null) {
            stats['updateTimes'][lang] = timestamp;
          }
        }
      }

      print('缓存统计: $stats');
      return stats;
    } catch (e) {
      print('获取缓存统计异常: $e');
      return {'error': e.toString()};
    }
  }
}
