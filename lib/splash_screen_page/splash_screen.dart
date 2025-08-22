import 'package:flutter/material.dart';
import '../forms/login_form.dart';
import '../forms/register_form.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

enum FormType { none, login, register }

class _SplashScreenState extends State<SplashScreen> {
  FormType _formType = FormType.none;

  void _showLoginForm() => setState(() => _formType = FormType.login);
  void _showRegisterForm() => setState(() => _formType = FormType.register);
  void _hideForm() => setState(() => _formType = FormType.none);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFedb023),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),

                SizedBox(height: 12),
                Text(
                  'dlb coin',
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 登录/注册按钮
          if (_formType == FormType.none)
            Positioned(
              bottom: 60,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _showLoginForm,
                    child: Text('登录'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 65),
                      backgroundColor: Color(0xFF292e38),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: _showRegisterForm,
                    child: Text('注册'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 65),
                      backgroundColor: Color(0xFFedb023),
                      foregroundColor: Colors.black,
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // 弹出表单
          AnimatedSlide(
            offset: _formType != FormType.none ? Offset(0, 0) : Offset(0, 1),
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  height: screenHeight * 0.60,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: _formType == FormType.login
                            ? LoginForm(
                                onSwitchToRegister: _showRegisterForm,
                              )
                            : RegisterForm(
                                onSwitchToLogin: _showLoginForm,
                              ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, size: 28),
                          onPressed: _hideForm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
