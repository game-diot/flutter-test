import 'services/i18n_service.dart';

class Lang {
  static String currentLang = 'zh';
  static final Map<String, String> _defaultChineseTranslations = {};

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
      'register_failed':
          'Registration failed, please check your info or try later',
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
      'login_button': 'Login',
      'enter_password': 'Enter Password',
      'reset_to_chinese': 'Reset to Chinese',
      'search_form': 'Search forum',
      'search_news': 'Search News',
      'search_forum': 'Search Forum',
      'hot_rank': 'Hot',
      'square': 'Square',
      'original': 'Original',
      'nft': 'NFT',
      'science': 'Science',
      'no_data': 'No data available',
      'no_square_data': 'No square data, please check later',
      'no_original_data': 'No original data, please check later',
      'no_nft_data': 'No NFT data, please check later',
      'no_science_data': 'No science data, please check later',

      'today_hot': 'Today\'s Hot',
      'weekly_must': 'Weekly Must',
      'hot_topics': 'Hot Topics',
      'rumor_zone': 'Rumor Zone',
      'my_posts': 'My Posts',
      'my_likes': 'My Likes',
      'edit_profile': 'Edit Profile',
      'favorites': 'Favorites',
      'liked': 'Liked',
      'commented': 'Commented',
      'change_color': 'Trend Color',
      'feedback': 'Feedback',
      'feedback_pending': 'Feedback feature not implemented',
      'switch_language': 'Switch Language',
      'logout_account': 'Logout Account',
      'logout_confirm': 'Confirm Logout',
      'logout_question': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'theme': 'Theme',
      'theme_light': 'Light',
      'theme_dark': 'Dark',
      'theme_system': 'System',
      'hot_search': 'hot',
      'main_coins': 'Main Coins',
      'hot_list': 'Hot',
      'gainers_list': 'Gainers',
      'exchanges': 'Exchanges',
      'name': 'Name',
      'price': 'Price',
      'price_change_percent': 'Change %',
      'blockchain': 'Blockchain',
      'experience': 'Experience',
      'complaint': 'Complaint',
      'tab': 'Tab',
      'trend_color': 'Trend Color',
      'search_pair': 'Search Pair',
      'fake_news': 'Fake News',
      'publish': 'Publish',
      'enter_post_title': 'Enter Post Title',
      'switch_other_tab':'Switch Other Tab',
      'no_blockchain_data': 'No blockchain data',
'no_experience_data': 'No experience data',
'no_complaint_data': 'No complaint data',
'no_tab_data': 'No tab data',

    },
    'zh': {
      'no_blockchain_data': '暂无区块链数据',
'no_experience_data': '暂无体验数据',
'no_complaint_data': '暂无投诉数据',
'no_tab_data': '暂无标签数据',
'no_data': '暂无数据',
      'switch_other_tab':'切换至其他标签页',
      'search_pair': '搜索交易对',
      'fake_news': '辟谣',
      'publish': '发布',
      'enter_post_title': '请输入帖子标题',
      'main_coins': '主流币',
      'hot_list': '热门榜单',
      'gainers_list': '涨幅榜',
      'exchanges': '交易所',
      'name': '名称',
      'price': '价格',
      'price_change_percent': '涨幅比',
      'blockchain': '区块链',
      'experience': '体验',
      'complaint': '投诉',
      'tab': '标签页',
      'trend_color': '涨跌颜色',
      'hot_search': '热搜',
      'search_forum': '搜索论坛',
      'today_hot': '今日热门',
      'weekly_must': '每周必看',
      'hot_topics': '热议话题',
      'rumor_zone': '辟谣专区',
      'my_posts': '我的帖子',
      'my_likes': '我的点赞',
      'edit_profile': '编辑资料',
      'favorites': '收藏',
      'liked': '被点赞',
      'commented': '被评论',
      'change_color': '涨跌颜色',
      'feedback': '意见反馈',
      'feedback_pending': '意见反馈功能待实现',
      'switch_language': '切换语言',
      'logout_account': '注销账号',
      'logout_confirm': '确认注销',
      'logout_question': '确定要注销当前账号吗？',
      'cancel': '取消',
      'confirm': '确认',
      'theme': '主题',
      'theme_light': '明亮',
      'theme_dark': '暗黑',
      'theme_system': '跟随系统',
      'search_news': '搜索新闻',
      'hot_rank': '热榜',
      'square': '广场',
      'original': '原创',
      'nft': 'NFT',
      'science': '科普',

      'no_square_data': '暂无广场数据，请稍后查看',
      'no_original_data': '暂无原创数据，请稍后查看',
      'no_nft_data': '暂无 NFT 数据，请稍后查看',
      'no_science_data': '暂无科普数据，请稍后查看',
      'search_form': '搜索论坛',
      'login_button': '登录',
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
      'enter_password': '输入密码',
      'reset_to_chinese': '恢复中文',
    },
  };

  /// 初始化默认中文翻译
  static void _initDefaultChineseTranslations() {
    if (_defaultChineseTranslations.isEmpty) {
      _defaultChineseTranslations.addAll(
        Map<String, String>.from(_translations['zh']!),
      );
      print('默认中文翻译已初始化，共 ${_defaultChineseTranslations.length} 条');
    }
  }

  /// 恢复到默认中文
  static void resetToDefaultChinese() {
    print('恢复到默认中文状态');
    _initDefaultChineseTranslations();

    // 重置当前语言为中文
    currentLang = 'zh';

    // 确保中文翻译存在
    _translations['zh'] = Map<String, String>.from(_defaultChineseTranslations);

    print('已恢复默认中文，当前语言: $currentLang');
    debugPrintStats();
  }

  /// 获取翻译文本
  static String t(String key, {Map<String, String>? params}) {
    // 确保默认中文翻译已初始化
    _initDefaultChineseTranslations();

    // 获取翻译文本的优先级：
    // 1. 当前语言的翻译
    // 2. 默认中文翻译
    // 3. 英文翻译
    // 4. key本身
    String text =
        _translations[currentLang]?[key] ??
        _defaultChineseTranslations[key] ??
        _translations['zh']?[key] ??
        _translations['en']?[key] ??
        key;

    // 参数替换
    if (params != null) {
      params.forEach((k, v) {
        text = text.replaceAll('{$k}', v);
      });
    }

    return text;
  }
 /// 外部翻译覆盖（例如从接口请求到的翻译包）
  static void overrideTranslations(
      String langCode, Map<String, String> externalTranslations) {
    if (_translations.containsKey(langCode)) {
      _translations[langCode]!.addAll(externalTranslations);
    } else {
      _translations[langCode] = externalTranslations;
    }
  }
  /// 设置当前语言
  static void setLang(String langCode) {
    print('设置语言: $langCode');

    if (_translations.containsKey(langCode)) {
      currentLang = langCode;
      print('语言设置成功: $langCode');
    } else {
      print('语言 $langCode 不存在，保持当前语言: $currentLang');
    }
  }

  /// 添加单个翻译
  static void addTranslation(String key, Map<String, String> values) {
    print('添加翻译: $key');

    values.forEach((lang, text) {
      _translations.putIfAbsent(lang, () => {});
      _translations[lang]![key] = text;
      print('  $lang: $text');
    });
  }

  /// 加载远程翻译数据
  static Future<bool> loadRemoteTranslations(String languageCode) async {
    try {
      print('=== 开始加载远程翻译: $languageCode ===');

      // 确保默认中文翻译已初始化
      _initDefaultChineseTranslations();

      final remoteTranslations = await I18nService.loadTranslations(
        languageCode,
      );

      if (remoteTranslations != null && remoteTranslations.isNotEmpty) {
        print('远程翻译数据获取成功: $languageCode, 共 ${remoteTranslations.length} 条');

        // 合并远程翻译到本地
        mergeTranslations(languageCode, remoteTranslations);

        // 更新当前语言
        currentLang = languageCode;

        print('远程翻译加载成功: $languageCode');
        return true;
      } else {
        print('远程翻译为空或加载失败: $languageCode，回退到默认中文');

        // 回退到默认中文
        _fallbackToDefaultChinese(languageCode);
        return false;
      }
    } catch (e, stackTrace) {
      print('加载远程翻译异常: $e');
      print('堆栈跟踪: $stackTrace');

      // 发生异常时，回退到默认中文
      _fallbackToDefaultChinese(languageCode);
      return false;
    }
  }

  /// 回退到默认中文处理
  static void _fallbackToDefaultChinese(String targetLanguageCode) {
    print('执行回退到默认中文处理');

    // 如果目标语言是中文，直接使用默认中文
    if (targetLanguageCode == 'zh') {
      currentLang = 'zh';
      _translations['zh'] = Map<String, String>.from(
        _defaultChineseTranslations,
      );
      print('目标语言是中文，直接使用默认中文翻译');
    } else {
      // 其他语言加载失败，回退到中文
      currentLang = 'zh';
      print('其他语言加载失败，已回退到默认中文: zh');
    }
  }

  /// 合并翻译数据
  static void mergeTranslations(
    String languageCode,
    Map<String, String> newTranslations,
  ) {
    print('=== 开始合并翻译数据: $languageCode ===');
    print('新翻译数据条数: ${newTranslations.length}');

    // 确保语言映射存在
    _translations.putIfAbsent(languageCode, () => {});

    final originalCount = _translations[languageCode]!.length;

    // 合并翻译（远程翻译会覆盖本地翻译）
    _translations[languageCode]!.addAll(newTranslations);

    final finalCount = _translations[languageCode]!.length;

    print('合并前本地翻译: $originalCount 条');
    print('合并后总翻译: $finalCount 条');
    print('新增翻译: ${finalCount - originalCount} 条');
    print('=== 翻译合并完成 ===');
  }

  /// 批量更新翻译
  static void updateTranslations(
    String languageCode,
    Map<String, String> translations,
  ) {
    print('批量更新翻译: $languageCode, 共 ${translations.length} 条');
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
    print('开始预加载多种语言: ${languageCodes.join(", ")}');

    for (final code in languageCodes) {
      print('预加载语言: $code');
      await loadRemoteTranslations(code);
    }

    print('预加载完成');
  }

  /// 清除指定语言的缓存
  static Future<void> clearCache(String languageCode) async {
    print('清除缓存: $languageCode');
    await I18nService.clearCache(languageCode);
  }

  /// 清除所有翻译缓存
  static Future<void> clearAllCache() async {
    print('清除所有翻译缓存');
    await I18nService.clearAllCache();
  }

  /// 获取翻译统计信息
  static Map<String, int> getTranslationStats() {
    final stats = <String, int>{};
    _translations.forEach((lang, translations) {
      stats[lang] = translations.length;
    });

    // 添加默认中文统计
    stats['default_zh'] = _defaultChineseTranslations.length;

    return stats;
  }

  /// 调试方法：打印当前翻译状态
  static void debugPrintStats() {
    print('================== 翻译统计信息 ==================');
    print('当前语言: $currentLang');
    print('默认中文翻译: ${_defaultChineseTranslations.length} 条');

    final stats = getTranslationStats();
    stats.forEach((lang, count) {
      final isCurrent = lang == currentLang ? ' (当前)' : '';
      print('$lang: $count 条翻译$isCurrent');
    });

    // 显示当前语言的部分翻译内容（调试用）
    final currentTranslations = _translations[currentLang];
    if (currentTranslations != null && currentTranslations.isNotEmpty) {
      print('当前语言翻译示例:');
      var count = 0;
      for (final entry in currentTranslations.entries) {
        if (count >= 5) break; // 只显示前5个
        print('  ${entry.key}: ${entry.value}');
        count++;
      }
    }

    print('================================================');
  }

  /// 检查当前语言是否有有效翻译
  static bool hasValidTranslations([String? languageCode]) {
    final lang = languageCode ?? currentLang;
    final translations = _translations[lang];
    final hasValid = translations != null && translations.isNotEmpty;

    print('检查语言 $lang 是否有有效翻译: $hasValid');
    if (hasValid) {
      print('翻译数量: ${translations.length}');
    }

    return hasValid;
  }

  /// 验证翻译完整性
  static Map<String, dynamic> validateTranslations() {
    print('开始验证翻译完整性');

    final result = <String, dynamic>{
      'currentLang': currentLang,
      'hasDefault': _defaultChineseTranslations.isNotEmpty,
      'languages': {},
      'missingKeys': <String, List<String>>{},
    };

    // 获取所有翻译key（以默认中文为基准）
    final allKeys = _defaultChineseTranslations.keys.toSet();

    // 检查每种语言的翻译完整性
    _translations.forEach((lang, translations) {
      result['languages'][lang] = {
        'count': translations.length,
        'coverage': translations.length / allKeys.length,
      };

      // 检查缺失的key
      final missingKeys = allKeys.difference(translations.keys.toSet());
      if (missingKeys.isNotEmpty) {
        result['missingKeys'][lang] = missingKeys.toList();
      }
    });

    print('翻译完整性验证完成');
    print('验证结果: ${result.toString()}');

    return result;
  }
}
