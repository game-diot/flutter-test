import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/model.dart'; // 你的 CoinDetail model 路径

class ApiService {
  static const String baseUrl =
      "https://us15-h5.yanshi.lol/api/app-api/pay/symbol/search";

  /// 请求并返回 CoinDetail 对象
  static Future<CoinDetail?> fetchCoinDetail(String symbol) async {
    try {
      // 🔍 调试信息：打印原始 symbol
      print("🚀 [API Request] Original symbol: $symbol");
      
      final url = Uri.parse(
        "$baseUrl?pageNo=1&pageSize=15&type=2&contractType=&symbol=$symbol",
      );
      
      // 🔍 调试信息：打印完整请求 URL
      print("🌐 [API Request] Full URL: $url");
      
      final response = await http.get(url);
      
      // 🔍 调试信息：打印响应状态
      print("📡 [API Response] Status Code: ${response.statusCode}");
      print("📡 [API Response] Headers: ${response.headers}");

      if (response.statusCode == 200) {
        // 🔍 调试信息：打印原始响应体
        print("📄 [API Response] Raw Body: ${response.body}");
        
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        
        // 🔍 调试信息：打印解析后的 JSON 结构
        print("🔧 [API Response] Parsed JSON: $jsonData");
        print("🔧 [API Response] Code: ${jsonData["code"]}");
        print("🔧 [API Response] Data exists: ${jsonData["data"] != null}");
        
        if (jsonData["code"] == 0 && jsonData["data"] != null) {
          final data = jsonData["data"];
          
          // 🔍 调试信息：打印 data 结构
          print("📊 [API Data] Data structure: $data");
          print("📊 [API Data] Data type: ${data.runtimeType}");
          
          // 检查 list 是否存在
          if (data.containsKey("list")) {
            print("📋 [API Data] List exists: ${data["list"] != null}");
            print("📋 [API Data] List type: ${data["list"].runtimeType}");
            
            if (data["list"] is List) {
              final list = data["list"] as List;
              print("📋 [API Data] List length: ${list.length}");
              
              if (list.isNotEmpty) {
                print("📋 [API Data] First item: ${list[0]}");
                
                try {
                  final coinDetail = CoinDetail.fromJson(list[0]);
                  print("✅ [API Success] CoinDetail created successfully");
                  print("✅ [API Success] Symbol: ${coinDetail.symbol}, Name: ${coinDetail.symbolName}");
                  return coinDetail;
                } catch (parseError) {
                  print("❌ [Parse Error] Failed to parse CoinDetail: $parseError");
                  print("❌ [Parse Error] Raw data: ${list[0]}");
                  return null;
                }
              } else {
                print("⚠️ [API Warning] List is empty");
              }
            } else {
              print("❌ [API Error] data['list'] is not a List, actual type: ${data["list"].runtimeType}");
            }
          } else {
            print("❌ [API Error] 'list' key not found in data");
            print("❌ [API Error] Available keys: ${data.keys.toList()}");
          }
        } else {
          print("❌ [API Error] Invalid response structure:");
          print("❌ [API Error] Code: ${jsonData["code"]} (expected: 0)");
          print("❌ [API Error] Data null: ${jsonData["data"] == null}");
          
          // 打印可能的错误信息
          if (jsonData.containsKey("msg")) {
            print("❌ [API Error] Message: ${jsonData["msg"]}");
          }
        }
        
        return null;
      } else {
        print("❌ [HTTP Error] Request failed with status: ${response.statusCode}");
        print("❌ [HTTP Error] Response body: ${response.body}");
        return null;
      }
    } catch (e, stackTrace) {
      print("💥 [Exception] Request exception: $e");
      print("💥 [Exception] Stack trace: $stackTrace");
      return null;
    }
  }
}