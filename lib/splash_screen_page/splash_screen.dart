import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFedb023), // 设置背景颜色
      body: Column(
        children: [
          // Logo and text in the center
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/splash_screen_page/logo.png', // Logo图片路径
                    width: 150,
                    height: 150,
                  ),
            
                  Text(
                    'dlb coin',
                    style: 
                      TextStyle(
                        fontFamily: 'CustomFont', // 自定义字体
                        color: Colors.white,  
                        fontSize: 40, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  
                ],
              ),
            ),
          ),

          // Login and Register buttons at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0), // 设置外边距
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 登录功能暂不实现
                  },
                  child: Text('登录'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 70),
                    backgroundColor: Color(0xFF292e38), // 登录按钮背景色
                    foregroundColor: Colors.white, // 文本颜色
                    textStyle: TextStyle(fontSize: 18),
                  ).copyWith(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // 设置圆角
                    )),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // 注册功能暂不实现
                  },
                  child: Text('注册'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 70),
                    backgroundColor: Color(0xFFedb023), // 注册按钮背景色
                    foregroundColor: Colors.black, // 文本颜色
                  
                    textStyle: TextStyle(fontSize: 18),
                  ).copyWith(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // 设置圆角
                    )),
                  ),
                ),
                   SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
