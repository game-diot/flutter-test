import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'enums/form_type.dart';
import 'components/buttons.dart';
import 'components/form_container.dart';
import '../../providers/login/login.dart';
import '../../providers/countries/countries.dart';
import '../../providers/language/language.dart';
import '../home_page/home.dart';
import '../../localization/i18n/lang.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FormType _formType = FormType.none;

  void _showLoginForm() => setState(() => _formType = FormType.login);
  void _showRegisterForm() => setState(() => _formType = FormType.register);
  void _hideForm() => setState(() => _formType = FormType.none);

  @override
  void initState() {
    super.initState();

    // 延迟到 build 完成后再调用异步加载，避免 build 阶段 setState 报错
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final countryProvider = context.read<CountryProvider>();
      final languageProvider = context.read<LanguageProvider>();

      try {
        await Future.wait([
          countryProvider.loadCountries(),
          languageProvider.loadTranslationsQuietly(
            languageProvider.currentCode,
          ),
          authProvider.checkLoginStatus(), // 自动登录检查
        ]);
      } catch (e) {
        print("初始化数据异常: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final screenHeight = MediaQuery.of(context).size.height;

    // 登录状态直接跳转 HomePage
    if (auth.isLoggedIn) {
      return const HomePage();
    }

    final double shiftOffset = _formType != FormType.none ? -50.0 : 0.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFedb023),
      body: Stack(
        children: [
          // Logo + App 名称
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: screenHeight * 0.2 + shiftOffset,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logo.png', width: 150, height: 100),
                Text(
                  Lang.t('dlb_coin'),
                  style: const TextStyle(
                    fontFamily: 'CustomFont',
                    color: Colors.black,
                    fontSize: 60,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          // 登录/注册按钮
          if (_formType == FormType.none)
            AuthButtons(onLogin: _showLoginForm, onRegister: _showRegisterForm),

          // 顶部返回栏
          if (_formType != FormType.none)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: 40,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _hideForm,
                      tooltip: Lang.t('back'),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          _formType == FormType.login
                              ? Lang.t('login')
                              : Lang.t('register'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

          // 表单容器
          if (_formType != FormType.none)
            Positioned.fill(
              left: 0,
              right: 0,
              bottom: 0,
              child: AuthFormContainer(
                formType: _formType,
                onSwitchToLogin: _showLoginForm,
                onSwitchToRegister: _showRegisterForm,
                onClose: _hideForm,
                screenHeight: screenHeight,
              ),
            ),
        ],
      ),
    );
  }
}
