import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';

class CompressionService {
  /// 解压Base64编码的gzip数据
  static Map<String, dynamic>? decompressGzipBase64(String compressedData) {
    try {
      // 1. Base64解码
      final bytes = base64.decode(compressedData);
      
      // 2. gzip解压
      final archive = GZipDecoder();
      final decompressed = archive.decodeBytes(bytes);
      
      // 3. 转换为UTF-8字符串
      final jsonString = utf8.decode(decompressed);
      
      // 4. JSON解析
      return json.decode(jsonString) as Map<String, dynamic>;
      
    } catch (e) {
      print('解压数据失败: $e');
      return null;
    }
  }

  /// 压缩数据为Base64编码的gzip格式
  static String? compressToGzipBase64(Map<String, dynamic> data) {
    try {
      // 1. 转换为JSON字符串
      final jsonString = json.encode(data);
      
      // 2. UTF-8编码
      final bytes = utf8.encode(jsonString);
      
      // 3. gzip压缩
      final archive = GZipEncoder();
      final compressed = archive.encode(bytes);
      
      // 4. Base64编码
      return base64.encode(compressed!);
      
    } catch (e) {
      print('压缩数据失败: $e');
      return null;
    }
  }

  /// 验证数据是否为有效的压缩格式
  static bool isValidCompressedData(String data) {
    try {
      final bytes = base64.decode(data);
      // 检查gzip魔数 (0x1f, 0x8b)
      return bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b;
    } catch (e) {
      return false;
    }
  }
}