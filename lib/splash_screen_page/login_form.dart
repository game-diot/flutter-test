import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isPhoneSelected = true; // 默认选择手机号
  String countryCode = "+86";
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 设置背景颜色为白色
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 外边距
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 两个按钮：手机号/邮箱
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPhoneSelected = true;
                    });
                  },
                  child: Text('手机号'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPhoneSelected ? Colors.white : Color(0xFFf4f4f5),
                    foregroundColor: isPhoneSelected ? Colors.black : Colors.black54,
                    minimumSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPhoneSelected = false;
                    });
                  },
                  child: Text('邮箱'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isPhoneSelected ? Colors.white : Color(0xFFf4f4f5),
                    foregroundColor: !isPhoneSelected ? Colors.black : Colors.black54,
                    minimumSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 输入框：国家国旗 +86 【手机号】
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    // 选择国家的逻辑
                  },
                ),
                Text('$countryCode'),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: isPhoneSelected ? '请输入手机号' : '请输入邮箱',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 密码输入框
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '请输入密码',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),
            // 登录按钮
            ElevatedButton(
              onPressed: () {
                // 登录功能逻辑
              },
              child: Text('登录'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF292e38),
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            // 注册按钮
            ElevatedButton(
              onPressed: () {
                // 注册功能逻辑
              },
              child: Text('注册'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFFedb023),
                foregroundColor: Colors.black,
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),
            // 协议部分
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('登录表示同意'),
                TextButton(
                  onPressed: () {
                    // 使用协议的点击事件
                  },
                  child: Text(
                    '使用协议',
                    style: TextStyle(color: Color(0xFFedb023)),
                  ),
                ),
                Text('/'),
                TextButton(
                  onPressed: () {
                    // 隐私协议的点击事件
                  },
                  child: Text(
                    '隐私协议',
                    style: TextStyle(color: Color(0xFFedb023)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
