import 'services/i18n_service.dart';

class Lang {
  static String currentLang = 'zh';

  static Map<String, Map<String, String>> _translations = {
    'en': {
      'dlb_coin': 'DLB Coin',
      'login': 'Login',
      'register': 'Register',
      'back': 'Back',
      'phone': 'Phone',
      'email': 'Email',
      'username_empty': 'Username cannot be empty',
      'password_empty': 'Password cannot be empty',
      'login_success': 'Login successful',
      'login_failed': 'Login failed, please check username or password',
      'enter_phone': 'Please enter phone number',
      'captcha_sent': 'Verification code sent',
      'captcha_send_failed': 'Failed to send',
      'network_error': 'Network request failed: {error}',
      'seconds': '{count} seconds',
      'send_captcha': 'Send Verification Code',
      'login_agree_text': 'By logging in, you agree to',
      'terms_of_use': 'Terms of Use',
      'privacy_policy': 'Privacy Policy',
      'slash': '/',
      'captcha_empty': 'Verification code cannot be empty',
      'email_empty': 'Email cannot be empty',
      'password_mismatch': 'Passwords do not match',
      'register_success': 'Registration successful, automatically logged in',
      'register_failed': 'Registration failed, please check your info or try later',
      'enter_captcha': 'Please enter verification code',
      'enter_password_again': 'Please enter password again',
      'have_account_login': 'Already have an account? Login',
      '@qq.com': '@qq.com',
      '@163.com': '@163.com',
      '@gmail.com': '@gmail.com',
      'market': 'Market',
      'news': 'News',
      'forum': 'Forum',
      'setting': 'Setting',
      'check_latest_news': 'Check the latest news',
      'image_load_failed': 'Image failed to load',
      'global_index': 'Global Index',
      'market_data': 'Market Data',
            'login_button':'login_button',
    },
    'zh': {
      'login_button':'登录',
      'market_data': '行情数据',
      'global_index': '全球指数',
      'image_load_failed': '图片加载失败',
      'check_latest_news': '立即查看最新资讯',
      'market': '行情',
      'news': '新闻',
      'forum': '论坛',
      'setting': '设置',
      'dlb_coin': 'DLB Coin',
      'login': '登录',
      'register': '注册',
      'back': '返回',
      'phone': '手机号',
      'email': '邮箱',
      'username_empty': '用户名不能为空',
      'password_empty': '密码不能为空',
      'login_success': '登录成功',
      'login_failed': '登录失败，请检查用户名或密码',
      'enter_phone': '请输入手机号',
      'captcha_sent': '验证码发送成功',
      'captcha_send_failed': '发送失败',
      'network_error': '网络请求失败：{error}',
      'seconds': '{count} 秒',
      'send_captcha': '发送验证码',
      'login_agree_text': '登录即表示同意',
      'terms_of_use': '使用协议',
      'privacy_policy': '隐私协议',
      'slash': '/',
      'captcha_empty': '验证码不能为空',
      'email_empty': '邮箱不能为空',
      'password_mismatch': '两次输入密码不一致',
      'register_success': '注册成功，已自动登录',
      'register_failed': '注册失败，请检查信息或稍后重试',
      'enter_captcha': '请输入验证码',
      'enter_password_again': '请再次输入密码',
      'have_account_login': '已有账号？去登录',
      '@qq.com': '@qq.com',
      '@163.com': '@163.com',
      '@gmail.com': '@gmail.com',
    },
  };

/// 设置当前语言为默认中文（内置翻译）
static void setDefaultTranslations() {
  currentLang = 'zh';
  // _translations['default'] 存储内置中文
  _translations['default'] = Map<String, String>.from(_translations['zh']!);
  print('已切换到默认中文（default）');
}

/// 获取默认翻译
static Map<String, String> getDefaultTranslations() {
  return Map<String, String>.from(_translations['zh']!);
}

  /// 获取翻译文本
  static String t(String key, {Map<String, String>? params}) {
    String text = _translations[currentLang]?[key] ?? 
                  _translations['en']?[key] ?? 
                  key;
                  
    if (params != null) {
      params.forEach((k, v) {
        text = text.replaceAll('{$k}', v);
      });
    }
    return text;
  }

  /// 设置当前语言
  static void setLang(String langCode) {
    if (_translations.containsKey(langCode)) {
      currentLang = langCode;
    }
  }

  /// 添加单个翻译
  static void addTranslation(String key, Map<String, String> values) {
    values.forEach((lang, text) {
      _translations.putIfAbsent(lang, () => {});
      _translations[lang]![key] = text;
    });
  }

  /// 加载远程翻译数据
  static Future<bool> loadRemoteTranslations(String languageCode) async {
    try {
      print('开始加载远程翻译: $languageCode');
      
      final remoteTranslations = await I18nService.loadTranslations(languageCode);
      
      if (remoteTranslations != null && remoteTranslations.isNotEmpty) {
        // 合并远程翻译到本地
        mergeTranslations(languageCode, remoteTranslations);
        
        // 更新当前语言
        currentLang = languageCode;
        
        print('远程翻译加载成功: $languageCode, 共 ${remoteTranslations.length} 条');
        return true;
      } else {
        print('远程翻译为空或加载失败: $languageCode');
        // 即使远程加载失败，也切换语言（使用默认翻译）
        currentLang = languageCode;
        return false;
      }
    } catch (e) {
      print('加载远程翻译异常: $e');
      // 发生异常时，仍然切换语言
      currentLang = languageCode;
      return false;
    }
  }

  /// 合并翻译数据
  static void mergeTranslations(String languageCode, Map<String, String> newTranslations) {
    // 确保语言映射存在
    _translations.putIfAbsent(languageCode, () => {});
    
    // 合并翻译（远程翻译会覆盖本地翻译）
    _translations[languageCode]!.addAll(newTranslations);
    
    print('合并翻译完成: $languageCode, 当前共有 ${_translations[languageCode]!.length} 条翻译');
  }

  /// 批量更新翻译
  static void updateTranslations(String languageCode, Map<String, String> translations) {
    _translations[languageCode] = translations;
    print('更新翻译完成: $languageCode');
  }

  /// 获取当前语言的所有翻译
  static Map<String, String> getCurrentTranslations() {
    return _translations[currentLang] ?? {};
  }

  /// 获取指定语言的所有翻译
  static Map<String, String> getTranslations(String languageCode) {
    return _translations[languageCode] ?? {};
  }

  /// 检查翻译key是否存在
  static bool hasTranslation(String key, [String? languageCode]) {
    final lang = languageCode ?? currentLang;
    return _translations[lang]?.containsKey(key) ?? false;
  }

  /// 获取所有支持的语言
  static List<String> getSupportedLanguages() {
    return _translations.keys.toList();
  }

  /// 预加载多种语言的翻译
  static Future<void> preloadLanguages(List<String> languageCodes) async {
    for (final code in languageCodes) {
      await loadRemoteTranslations(code);
    }
  }

  /// 清除指定语言的缓存
  static Future<void> clearCache(String languageCode) async {
    await I18nService.clearCache(languageCode);
  }

  /// 清除所有翻译缓存
  static Future<void> clearAllCache() async {
    await I18nService.clearAllCache();
  }

  /// 获取翻译统计信息
  static Map<String, int> getTranslationStats() {
    final stats = <String, int>{};
    _translations.forEach((lang, translations) {
      stats[lang] = translations.length;
    });
    return stats;
  }

  /// 调试方法：打印当前翻译状态
  static void debugPrintStats() {
    print('=== 翻译统计信息 ===');
    print('当前语言: $currentLang');
    final stats = getTranslationStats();
    stats.forEach((lang, count) {
      print('$lang: $count 条翻译');
    });
    print('==================');
  }
}
