// lib/models/forum_message.dart
class News {
  final String id;
  final DateTime createTime;
  final String? imgUrl;
  final String authorityName;
  final int likeCount;
  final String messageTitle;
  final int viewVolume;
  final int sort;
  final String messageContent;
  final String authorityAvatar;
  final bool likeStatus;

  News({
    required this.id,
    required this.createTime,
    this.imgUrl,
    required this.authorityName,
    required this.likeCount,
    required this.messageTitle,
    required this.viewVolume,
    required this.sort,
    required this.messageContent,
    required this.authorityAvatar,
    required this.likeStatus,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
      imgUrl: json['imgUrl'],
      authorityName: json['authorityName'],
      likeCount: json['likeCount'],
      messageTitle: json['messageTitle'],
      viewVolume: json['viewVolume'],
      sort: json['sort'],
      messageContent: json['messageContent'],
      authorityAvatar: json['authorityAvatar'],
      likeStatus: json['likeStatus'],
    );
  }
}

class NewsResponse {
  final int code;
  final List<News> list;

  NewsResponse({required this.code, required this.list});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    var listJson = json['data']['list'] as List<dynamic>;
    List<News> messages =
        listJson.map((e) => News.fromJson(e)).toList();
    return NewsResponse(code: json['code'], list: messages);
  }
}
