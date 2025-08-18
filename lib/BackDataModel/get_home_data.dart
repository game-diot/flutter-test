import 'dart:convert';
// 需要先运行 flutter pub add http 添加http依赖包
import 'package:http/http.dart' as http;

Future<SymbolResponse> fetchSymbols() async {
  final uri = Uri.parse(
      'https://us12-h5.yanshi.lol/api/app-api/pay/symbol/search?pageNo=1&pageSize=10&plate=&type=1&priceSort=0&upDownRangSort=0&fuzzy=');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return SymbolResponse.fromJson(data);
  } else {
    throw Exception('Failed to load symbols');
  }
}
