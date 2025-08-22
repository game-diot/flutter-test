import 'package:dio/dio.dart';
import 'package:flutter_test_project/network/urls/all_api_url.dart';
import '../../models/home_page/data_picture.dart';

class SymbolService {
  

  final Dio _dio = Dio();

  Future<SymbolResponse> fetchSymbols() async {
    try {
      final response = await _dio.get(AllApiUrl.dataShowUrl);
      if (response.statusCode == 200) {
        return SymbolResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}
