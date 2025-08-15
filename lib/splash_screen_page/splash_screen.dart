import 'package:flutter/material.dart';
import 'login_form.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showButtons = true; // 控制按钮是否显示，默认显示

  @override
  void initState() {
    super.initState();
    // 可以在这里添加延迟显示逻辑，如果需要的话
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFedb023), // 设置背景颜色
      body: Stack(
        children: [
          // Logo and text in the center
          Center(
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
                  style: TextStyle(
                    fontFamily: 'CustomFont', // 自定义字体
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 动画的按钮
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showButtons ? 50 : -150, // 当按钮显示时从底部50像素的位置滑上来
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 导航到登录页面
                      Navigator.pushNamed(context, '/login');
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
                      // 导航到注册页面
                      Navigator.pushNamed(context, '/register');
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
          ),
          // 登录表单
          LoginForm(),
        ],
      ),
    );
  }
}
