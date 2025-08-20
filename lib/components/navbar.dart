import 'package:flutter/material.dart';
import '../add_page/add.dart';

class Navbar extends StatelessWidget {
  final ValueChanged<int> onTabSelected;
  final int currentIndex;

  Navbar({required this.onTabSelected, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color.fromRGBO(134, 144, 156, 0.4), width: 1), 
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        selectedItemColor: const Color.fromRGBO(41, 46, 56, 1),
        unselectedItemColor: const Color.fromRGBO(134, 144, 156, 1),
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPage()),
            );
          } else {
            onTabSelected(index);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: '行情',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '新闻',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              size: 50,
              color: Color.fromRGBO(237, 176, 35, 1),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud, size: 30),
            label: '论坛',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
