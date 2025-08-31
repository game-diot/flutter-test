import 'package:flutter/material.dart';
import '../../../localization/i18n/lang.dart';
import '../../detail_page/detail_page.dart';

class ForumPostBlock extends StatelessWidget {
  final String title;
  final String author;
  final String content;
  final int likes;
  final int comments;
  final int? rank;

  const ForumPostBlock({
    Key? key,
    required this.title,
    required this.author,
    required this.content,
    this.likes = 0,
    this.comments = 0,
    this.rank,
  }) : super(key: key);

  Color getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.deepOrange;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;
    final titleColor = isDark
        ? const Color.fromRGBO(223, 229, 236, 1)
        : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.grey[600];
    final iconColor = const Color.fromRGBO(237, 176, 35, 1);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(
              title: title,
              avatarUrl: 'https://example.com/user.jpg',
              nickname: author,
              time: DateTime.now().toString(),
              content: content,
              starCount: likes,
              likeCount: likes,
              commentCount: comments,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 30,
                            color: iconColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            author,
                            style: TextStyle(
                              fontSize: 16,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        content,
                        style: TextStyle(fontSize: 12, color: subtitleColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '$likes',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            Lang.t('like'),
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '/',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$comments',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                          Text(
                            Lang.t('comment'),
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (rank != null)
            Positioned(
              left: 16,
              top: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 1.5,
                ),
                decoration: BoxDecoration(
                  color: getRankColor(rank!),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
