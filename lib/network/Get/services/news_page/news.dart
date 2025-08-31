// lib/services/forum_message_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/news_page/news.dart';

class NewsServices {
  static const String baseUrl =
      'https://us14-h5.yanshi.lol/api/app-api/notice/forum-message/page';

  Future<NewsResponse> fetchNewsMessages({
    int pageNo = 1,
    int pageSize = 50,
  }) async {
    final url = Uri.parse('$baseUrl?pageNo=$pageNo&pageSize=$pageSize');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return NewsResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load forum messages: ${response.statusCode}');
    }
  }
}
