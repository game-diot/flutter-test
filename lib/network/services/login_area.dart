import 'package:dio/dio.dart';
import 'package:flutter_test_project/network/models/login_area.dart';

Future<List<Country>> fetchCountries() async {
  final dio = Dio();
  final response = await dio.get(
    'https://us14-h5.yanshi.lol/api/app-api/system/area-manage/list',
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['数据'] ?? response.data['data'] ?? [];
    return data.map((e) => Country.fromJson(e)).toList();
  } else {
    throw Exception('请求失败: ${response.statusCode}');
  }
}
