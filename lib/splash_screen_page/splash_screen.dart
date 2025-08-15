import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isFormVisible = false; // 控制表单是否显示
  String _currentButton = ""; // 当前点击的按钮，用于判断显示的表单内容

  // 切换表单显示状态
  void _toggleForm(String buttonType) {
    setState(() {
      _isFormVisible = !_isFormVisible; // 控制表单显示
      _currentButton = buttonType; // 保存点击的按钮（登录/注册）
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 背景色
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.ac_unit, // 你可以换成自己的图标
              size: 100,
              color: Colors.blue, // 图标颜色
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                '欢迎使用我们的应用！',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            // 登录按钮
            ElevatedButton(
              onPressed: () => _toggleForm("login"),
              child: Text('登录'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // 按钮宽高
                backgroundColor: Colors.blue, // 按钮颜色
                textStyle: TextStyle(fontSize: 18), // 按钮文本样式
              ),
            ),
            SizedBox(height: 20), // 按钮之间的间距
            // 注册按钮
            ElevatedButton(
              onPressed: () => _toggleForm("register"),
              child: Text('注册'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            // 表单动画部分
            AnimatedContainer(
              duration: Duration(seconds: 1), // 动画持续时间
              curve: Curves.easeInOut, // 动画曲线
              height: _isFormVisible ? 350 : 0, // 动画显示/隐藏表单
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)],
              ),
              child: _isFormVisible
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 手机号、邮箱选择按钮
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('手机号'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('邮箱'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // 输入框：手机号
                        Row(
                          children: [
                            Text('+86', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: '请输入手机号',
                                  hintText: '请输入手机号',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // 输入框：密码
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '密码',
                            hintText: '请输入密码',
                          ),
                        ),
                        SizedBox(height: 20),
                        // 登录和注册按钮（根据当前点击的按钮显示不同的文字）
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // 跳转到首页
                                Navigator.pushReplacementNamed(context, '/home');
                              },
                              child: Text(_currentButton == "login" ? '登录' : '注册'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(200, 50),
                                backgroundColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(), // 表单不显示时返回空容器
            ),
          ],
        ),
      ),
    );
  }
}
