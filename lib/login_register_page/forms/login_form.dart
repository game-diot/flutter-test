import 'package:flutter/material.dart';
import '../../home_page/home.dart';
import '../../network/Get/models/splash_page/login_area.dart';
import '../../network/Post/services/login_page/login_request.dart';
import '../../network/Post/models/login_page/login_request.dart';
import 'login_form_widget/login_form_country_widget.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onSwitchToRegister;
  final VoidCallback? onLoginSuccess;

  const LoginForm({this.onSwitchToRegister, this.onLoginSuccess, Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isPhoneSelected = true;
  String selectedEmailSuffix = "@qq.com";
  Country? selectedCountry;

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // 点击空白收起键盘
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              _buildSwitchButtons(),
              SizedBox(height: 28),
              isPhoneSelected ? _buildPhoneInput() : _buildEmailInput(),
              SizedBox(height: 22),
              _buildPasswordInput(),
              SizedBox(height: 28),
              _buildLoginButton(),
              SizedBox(height: 18),
              _buildSwitchRegisterButton(),
              SizedBox(height: 18),
              _buildAgreementText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => isPhoneSelected = true),
            child: Text('手机号'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isPhoneSelected ? Color(0xFFf4f4f5) : Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => isPhoneSelected = false),
            child: Text('邮箱'),
            style: ElevatedButton.styleFrom(
              backgroundColor: !isPhoneSelected ? Color(0xFFf4f4f5) : Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Row(
      children: [
        Container(
          width: 100,
          child: CountrySelectWidget(
            onSelected: (country) => setState(() => selectedCountry = country),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: phoneController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: '请输入手机号',
              hintStyle: TextStyle(color: Colors.black),
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: emailController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: '请输入邮箱',
              hintStyle: TextStyle(color: Colors.black),
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 120,
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            value: selectedEmailSuffix,
            isExpanded: true,
            underline: SizedBox(),
            items: ["@qq.com", "@163.com", "@gmail.com"]
                .map((suffix) => DropdownMenuItem(
                      value: suffix,
                      child: Text(suffix, style: TextStyle(color: Colors.black)),
                    ))
                .toList(),
            onChanged: (value) => setState(() => selectedEmailSuffix = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordInput() {
    return TextField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: '请输入密码',
        hintStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text('登录', style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF292e38),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    String username = isPhoneSelected
        ? phoneController.text
        : emailController.text + selectedEmailSuffix;
    String password = passwordController.text;

    final request = LoginRequest(
      username: username,
      password: password,
      areaCode: selectedCountry?.areaCode ?? '1',
    );

    bool success = await AuthService.login(request);

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "登录成功" : "登录失败，请检查用户名或密码")),
    );

    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      widget.onLoginSuccess?.call();
    }
  }

  Widget _buildSwitchRegisterButton() {
    return TextButton(
      onPressed: widget.onSwitchToRegister,
      child: Text('没有账号？去注册', style: TextStyle(color: Color(0xFFedb023), fontSize: 18)),
    );
  }

  Widget _buildAgreementText() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        Text('登录即表示同意', style: TextStyle(color: Colors.black)),
        TextButton(onPressed: () {}, child: Text('使用协议', style: TextStyle(color: Color(0xFFedb023)))),
        Text('/'),
        TextButton(onPressed: () {}, child: Text('隐私协议', style: TextStyle(color: Color(0xFFedb023)))),
      ],
    );
  }
}
