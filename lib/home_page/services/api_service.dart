import 'package:dio/dio.dart';
import '../models/symbol_item.dart';

class ApiService {
  static final Dio _dio = Dio();

  static const String _baseUrl =
      'https://us14-h5.yanshi.lol/api/app-api/pay/symbol/search?pageNo=1&pageSize=10&plate=&type=1&priceSort=0&upDownRangSort=0&fuzzy=';

  static Future<List<SymbolItem>> fetchSymbols() async {
    try {
      final response = await _dio.get(_baseUrl);

      if (response.statusCode == 200) {
        final dataList = response.data['data']['list'] as List;
        return dataList.map((e) => SymbolItem.fromJson(e)).toList();
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      print('请求异常: $e');
      rethrow;
    }
  }
}
