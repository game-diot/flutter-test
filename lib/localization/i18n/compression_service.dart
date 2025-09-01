import 'dart:convert';
import 'package:archive/archive.dart';

class CompressionService {
  static Map<String, dynamic>? decompressGzipBase64(String compressedData) {
    try {
      final bytes = base64.decode(compressedData);
      if (bytes.length < 2 || bytes[0] != 0x1f || bytes[1] != 0x8b) return null;
      final archive = GZipDecoder();
      final decompressed = archive.decodeBytes(bytes);
      return json.decode(utf8.decode(decompressed)) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static String? compressToGzipBase64(Map<String, dynamic> data) {
    try {
      final bytes = utf8.encode(json.encode(data));
      final archive = GZipEncoder();
      return base64.encode(archive.encode(bytes));
    } catch (_) {
      return null;
    }
  }

  static bool isValidCompressedData(String data) {
    try {
      final bytes = base64.decode(data);
      return bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b;
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
      return json.decode(utf8.decode(decoded)) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
