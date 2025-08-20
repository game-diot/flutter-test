import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: Color.fromARGB(255, 63, 61, 51),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 垂直居中
        children: [
          // 书本图标
          Padding(
            padding: EdgeInsets.only(top: 2), // 向下偏移 1px
            child: SvgPicture.asset(
              'assets/images/book.svg',
              width: 30,
              height: 28,
              color: Color.fromRGBO(237, 176, 35, 1),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '立即查看最新资讯',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),

          Icon(
            Icons.arrow_forward,
            size: 18,
            color: Color.fromRGBO(237, 176, 35, 1),
          ),
        ],
      ),
    );
  }
}
