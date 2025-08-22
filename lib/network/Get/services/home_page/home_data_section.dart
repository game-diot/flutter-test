import 'package:dio/dio.dart';
import '../../models/home_page/home_data_section.dart';
import '../../../urls/all_api_url.dart';
class ApiService {
  static final Dio _dio = Dio();


  static Future<List<SymbolItem>> fetchSymbols() async {
    try {
      final response = await _dio.get(AllApiUrl.home_data_section_Url);

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
