import 'package:flutter/material.dart';
import 'register_form.dart';
import '../home_page/home.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onSwitchToRegister;

  const LoginForm({this.onSwitchToRegister});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isPhoneSelected = true;
  String selectedPhoneSuffix = "+86";
  String selectedEmailSuffix = "@qq.com";

  final List<String> phoneSuffixes = ["+86", "+99", "+66"];
  final List<String> emailSuffixes = ["@qq.com", "@163.com", "@gmail.com"];

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 顶部切换按钮
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => isPhoneSelected = true),
                  child: Text('手机号'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPhoneSelected
                        ? Color(0xFFf4f4f5)
                        : Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => isPhoneSelected = false),
                  child: Text('邮箱'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isPhoneSelected
                        ? Color(0xFFf4f4f5)
                        : Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          isPhoneSelected
              ? Row(
                  children: [
                    Container(
                      width: 90,
                      child: DropdownButton<String>(
                        value: selectedPhoneSuffix,
                        isExpanded: true,
                        underline: SizedBox(),
                        items: phoneSuffixes
                            .map(
                              (suffix) => DropdownMenuItem(
                                value: suffix,
                                child: Text(suffix),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedPhoneSuffix = value!),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          hintText: '请输入手机号',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: '请输入邮箱',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 120,
                      child: DropdownButton<String>(
                        value: selectedEmailSuffix,
                        isExpanded: true,
                        underline: SizedBox(),
                        items: emailSuffixes
                            .map(
                              (suffix) => DropdownMenuItem(
                                value: suffix,
                                child: Text(suffix),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedEmailSuffix = value!),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 20),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: '请输入密码',
              contentPadding: EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // 登录逻辑完成后，跳转到 HomePage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('登录', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF292e38),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: widget.onSwitchToRegister,
            child: Text('没有账号？去注册', style: TextStyle(color: Color(0xFFedb023))),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              Text('登录即表示同意'),
              TextButton(
                onPressed: () {},
                child: Text('使用协议', style: TextStyle(color: Color(0xFFedb023))),
              ),
              Text('/'),
              TextButton(
                onPressed: () {},
                child: Text('隐私协议', style: TextStyle(color: Color(0xFFedb023))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
