import 'dart:convert';

import 'package:archive/archive.dart';

class CompressionService {
  /// 解压Base64编码的gzip数据
  static Map<String, dynamic>? decompressGzipBase64(String compressedData) {
    try {
      print('开始解压Base64 gzip数据，长度: ${compressedData.length}');
      
      // 1. 验证Base64格式
      if (!_isValidBase64(compressedData)) {
        print('无效的Base64格式');
        return null;
      }
      
      // 2. Base64解码
      final bytes = base64.decode(compressedData);
      print('Base64解码成功，字节长度: ${bytes.length}');
      
      // 3. 验证gzip魔数
      if (bytes.length < 2 || bytes[0] != 0x1f || bytes[1] != 0x8b) {
        print('无效的gzip魔数: ${bytes.take(2).toList()}');
        return null;
      }
      print('gzip魔数验证通过');
      
      // 4. gzip解压
      final archive = GZipDecoder();
      final decompressed = archive.decodeBytes(bytes);
      print('gzip解压成功，解压后字节长度: ${decompressed.length}');
      
      // 5. 转换为UTF-8字符串
      final jsonString = utf8.decode(decompressed);
      print('UTF-8解码成功，字符串长度: ${jsonString.length}');
      
      // 6. JSON解析
      final parsed = json.decode(jsonString);
      print('JSON解析成功，数据类型: ${parsed.runtimeType}');
      
      if (parsed is Map<String, dynamic>) {
        print('返回Map数据，键数量: ${parsed.keys.length}');
        return parsed;
      } else {
        print('解析结果不是Map类型: ${parsed.runtimeType}');
        return null;
      }
      
    } catch (e, stackTrace) {
      print('解压数据失败: $e');
      print('堆栈跟踪: $stackTrace');
      return null;
    }
  }

  /// 压缩数据为Base64编码的gzip格式
  static String? compressToGzipBase64(Map<String, dynamic> data) {
    try {
      print('开始压缩数据为gzip Base64格式');
      
      // 1. 转换为JSON字符串
      final jsonString = json.encode(data);
      print('JSON编码成功，字符串长度: ${jsonString.length}');
      
      // 2. UTF-8编码
      final bytes = utf8.encode(jsonString);
      print('UTF-8编码成功，字节长度: ${bytes.length}');
      
      // 3. gzip压缩
      final archive = GZipEncoder();
      final compressed = archive.encode(bytes);
      

      print('gzip压缩成功，压缩后字节长度: ${compressed.length}');
      
      // 4. Base64编码
      final base64String = base64.encode(compressed);
      print('Base64编码成功，最终长度: ${base64String.length}');
      
      return base64String;
      
    } catch (e, stackTrace) {
      print('压缩数据失败: $e');
      print('堆栈跟踪: $stackTrace');
      return null;
    }
  }

  /// 验证数据是否为有效的压缩格式
  static bool isValidCompressedData(String data) {
    try {
      print('验证压缩数据格式，数据长度: ${data.length}');
      
      if (!_isValidBase64(data)) {
        print('Base64格式验证失败');
        return false;
      }
      
      final bytes = base64.decode(data);
      print('Base64解码成功，验证gzip魔数');
      
      // 检查gzip魔数 (0x1f, 0x8b)
      final isValid = bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b;
      print('gzip魔数验证结果: $isValid');
      
      return isValid;
    } catch (e) {
      print('压缩数据验证异常: $e');
      return false;
    }
  }

  /// 验证Base64格式
  static bool _isValidBase64(String str) {
    try {
      // Base64字符集验证
      final base64Regex = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
      if (!base64Regex.hasMatch(str)) {
        return false;
      }
      
      // 长度验证（必须是4的倍数）
      if (str.length % 4 != 0) {
        return false;
      }
      
      // 尝试解码验证
      base64.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 尝试不同的解压方法
  static Map<String, dynamic>? tryDecompressVariants(String data) {
    print('尝试多种解压方法');
    
    // 方法1: 直接gzip解压
    try {
      print('尝试方法1: 直接gzip解压');
      final result = decompressGzipBase64(data);
      if (result != null) {
        print('方法1成功');
        return result;
      }
    } catch (e) {
      print('方法1失败: $e');
    }

    // 方法2: 尝试去除换行符和空格
    try {
      print('尝试方法2: 清理数据格式');
      final cleanData = data.replaceAll(RegExp(r'\s+'), '');
      final result = decompressGzipBase64(cleanData);
      if (result != null) {
        print('方法2成功');
        return result;
      }
    } catch (e) {
      print('方法2失败: $e');
    }

    // 方法3: 尝试直接JSON解析（可能不是压缩数据）
    try {
      print('尝试方法3: 直接JSON解析');
      final decoded = base64.decode(data);
      final jsonString = utf8.decode(decoded);
      final parsed = json.decode(jsonString);
      
      if (parsed is Map<String, dynamic>) {
        print('方法3成功: 数据未压缩');
        return parsed;
      }
    } catch (e) {
      print('方法3失败: $e');
    }

    print('所有解压方法均失败');
    return null;
  }
}