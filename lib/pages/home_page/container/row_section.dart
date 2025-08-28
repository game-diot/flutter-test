import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../localization/lang.dart'; // 替换成实际路径

class RowSection extends StatelessWidget {
  const RowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      color: const Color.fromARGB(255, 63, 61, 51),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 垂直居中
        children: [
          // 书本图标
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 16), // 向下偏移 2px
            child: SvgPicture.asset(
              'assets/images/book.svg',
              width: 20,
              height: 20,
              color: const Color.fromRGBO(237, 176, 35, 1),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            Lang.t('check_latest_news'), // 使用 Lang 国际化
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward,
            size: 20,
            color: Color.fromRGBO(237, 176, 35, 1),
          ),
        ],
      ),
    );
  }
}
