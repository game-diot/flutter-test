import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      
      children: [
        // 头像部分
        SizedBox(width: 16),
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          child: Icon(
            Icons.person,
            size: 30,
               color: Color.fromRGBO(237, 176, 35, 1),
          ),
        ),
        SizedBox(width: 20),
        // 搜索框部分
        Container(
          width: 200,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey),
            color: Color(0xfff2f2f2),
          ),
          child: Row(
            children: [
               Icon(
                Icons.search,
                color: Colors.grey,
                size: 24,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '搜索币对',
                    border: InputBorder.none,
                  ),
                ),
              ),
             
            ],
          ),
        ),
        SizedBox(width: 20),
        // 地球地区部分
        Row(
          children: [
            Icon(Icons.public, size: 36), // 地球图标
            SizedBox(width: 16),
          ],
        ),
        SizedBox(width: 4),
        // 切换主题图标部分
        IconButton(
          icon: Icon(Icons.brightness_6, size: 36), // 切换主题图标
          onPressed: () {
            // 实现切换主题功能
          },
        ),
      ],
    );
  }
}
