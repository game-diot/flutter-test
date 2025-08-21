import 'package:flutter/material.dart';

class DetailUserInfo extends StatelessWidget {
  final String avatarUrl;
  final String nickname;
  final String time;

  const DetailUserInfo({
    super.key,
    required this.avatarUrl,
    required this.nickname,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=2"),
            radius: 18,
          ),
          const SizedBox(width: 8),
          Text(nickname),
          const Spacer(),
          Text(
            time,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
