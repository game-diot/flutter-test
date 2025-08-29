import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../providers/language/language.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 紧凑版重置按钮 - 适合AppBar等狭窄空间
class CompactResetToChineseButton extends StatelessWidget {
  final Color? iconColor;
  final double? iconSize;

  const CompactResetToChineseButton({
    Key? key,
    this.iconColor,
    this.iconSize = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final isCurrentlyChinese = languageProvider.currentCode == 'zh';

        return IconButton(
          onPressed: languageProvider.isLoading
              ? null
              : () async {
                  await languageProvider.resetToDefaultChinese();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('已恢复中文'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
          icon: languageProvider.isLoading
              ? SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  isCurrentlyChinese ? Icons.translate : Icons.refresh,
                  color:
                      iconColor ??
                      (isCurrentlyChinese ? Colors.green : Colors.orange),
                  size: iconSize,
                ),
          tooltip: isCurrentlyChinese ? '当前中文' : '恢复中文',
        );
      },
    );
  }
}

/// ======================
/// 语言选择页面
/// ======================

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  List<dynamic> _languages = [];
  List<dynamic> _filteredLanguages = [];
  bool _loading = true;
  String _search = '';
  String? _switchingLanguage;

  @override
  void initState() {
    super.initState();
    _fetchLanguages();
  }

 Future<void> _fetchLanguages() async {
  try {
    // 1. 先尝试读取缓存
    final cached = await Provider.of<LanguageProvider>(context, listen: false).loadLanguageListCache();
    if (cached != null && cached.isNotEmpty) {
      setState(() {
        _languages = cached;
        _filteredLanguages = _languages;
        _loading = false;
      });
      print("已使用缓存的语言列表");
    }

    // 2. 再请求接口更新（后台刷新）
    final response = await http.get(
      Uri.parse('https://us14-h5.yanshi.lol/api/app-api/system/i18n-type/list'),
    );
    final result = json.decode(response.body);
    if (result['code'] == 0) {
      final data = result['data'];
      setState(() {
        _languages = data;
        _filteredLanguages = _languages;
        _loading = false;
      });

      // 保存到缓存
      await Provider.of<LanguageProvider>(context, listen: false).saveLanguageListCache(data);
    }
  } catch (e) {
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('加载语言列表失败: $e')));
  }
}


  void _filterLanguages(String keyword) {
    setState(() {
      _search = keyword;
      _filteredLanguages = _languages
          .where(
            (lang) =>
                lang['name'].toString().toLowerCase().contains(
                  keyword.toLowerCase(),
                ) ||
                lang['nameEn'].toString().toLowerCase().contains(
                  keyword.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  Future<void> _handleLanguageSwitch(String code, String name) async {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    if (_switchingLanguage == code || languageProvider.currentCode == code) {
      return;
    }

    setState(() {
      _switchingLanguage = code;
    });

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text('正在切换到 $name...'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      await languageProvider.setLanguage(code, name);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Text('已切换到 $name'),
              ],
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Text('切换失败: ${e.toString()}'),
              ],
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _switchingLanguage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final currentCode = languageProvider.currentCode;
        final isProviderLoading = languageProvider.isLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text("语言国际化切换"),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor:
                theme.appBarTheme.backgroundColor ??
                theme.scaffoldBackgroundColor,
            foregroundColor:
                theme.appBarTheme.foregroundColor ??
                theme.textTheme.titleLarge?.color,
            elevation: 0,
            actions: [
              // 紧凑版重置按钮
              const CompactResetToChineseButton(),
            ],
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (isProviderLoading)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        color: theme.primaryColor.withOpacity(0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  theme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '正在加载翻译包...',
                              style: TextStyle(color: theme.primaryColor),
                            ),
                          ],
                        ),
                      ),

                    if (languageProvider.error != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        color: Colors.orange.withOpacity(0.1),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                languageProvider.error!,
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ),
                            TextButton(
                              onPressed: languageProvider.retryLoadTranslations,
                              child: const Text('重试'),
                            ),
                          ],
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: _filterLanguages,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromRGBO(241, 245, 249, 1),
                          prefixIcon: const Icon(Icons.search),
                          hintText: '搜索',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredLanguages.length,
                        itemBuilder: (context, index) {
                          final lang = _filteredLanguages[index];
                          final code = lang['code'];
                          final name = lang['name'];
                          final avatar = lang['avatar'];

                          final isSelected = code == currentCode;
                          final isSwitching = _switchingLanguage == code;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(avatar),
                              radius: 16,
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: isSelected
                                ? Text(
                                    '当前语言',
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontSize: 12,
                                    ),
                                  )
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSwitching)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else if (isSelected)
                                  SvgPicture.asset(
                                    'assets/svgs/done.svg',
                                    width: 30,
                                    height: 30,
                                    color: theme.colorScheme.primary,
                                  ),
                              ],
                            ),
                            onTap: isSwitching
                                ? null
                                : () {
                                    _handleLanguageSwitch(code, name);
                                  },
                            tileColor: isSelected
                                ? theme.primaryColor.withOpacity(0.05)
                                : null,
                            shape: isSelected
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: theme.primaryColor.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
