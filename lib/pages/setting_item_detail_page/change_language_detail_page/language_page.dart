import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../providers/language/language.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  String? _switchingLanguage; // 正在切换的语言code

  @override
  void initState() {
    super.initState();
    _fetchLanguages();
  }

  Future<void> _fetchLanguages() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://us14-h5.yanshi.lol/api/app-api/system/i18n-type/list',
        ),
      );
      final result = json.decode(response.body);
      if (result['code'] == 0) {
        setState(() {
          _languages = result['data'];
          _filteredLanguages = _languages;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载语言列表失败: $e')),
      );
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

  /// 处理语言切换
  Future<void> _handleLanguageSwitch(String code, String name) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    // 如果正在切换相同语言，忽略
    if (_switchingLanguage == code || languageProvider.currentCode == code) {
      return;
    }

    setState(() {
      _switchingLanguage = code;
    });

    try {
      // 显示切换提示
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

      // 执行语言切换
      await languageProvider.setLanguage(code, name);

      // 切换成功提示
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
      // 切换失败提示
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
            backgroundColor: theme.appBarTheme.backgroundColor ?? 
                           theme.scaffoldBackgroundColor,
            foregroundColor: theme.appBarTheme.foregroundColor ??
                           theme.textTheme.titleLarge?.color,
            elevation: 0,
            actions: [
              // 调试按钮（生产环境可移除）
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  languageProvider.debugPrint();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('翻译统计'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('当前语言: ${languageProvider.language} (${languageProvider.currentCode})'),
                          const SizedBox(height: 8),
                          Text('加载状态: ${isProviderLoading ? "加载中" : "空闲"}'),
                          if (languageProvider.error != null) ...[
                            const SizedBox(height: 8),
                            Text('错误: ${languageProvider.error}', 
                                 style: const TextStyle(color: Colors.red)),
                          ],
                          const SizedBox(height: 12),
                          const Text('翻译统计:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...languageProvider.getTranslationStats().entries.map(
                            (e) => Text('${e.key}: ${e.value} 条'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('关闭'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            languageProvider.clearTranslationCache();
                          },
                          child: const Text('清除缓存'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // 全局加载状态指示器
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
                                valueColor: AlwaysStoppedAnimation(theme.primaryColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('正在加载翻译包...', 
                                 style: TextStyle(color: theme.primaryColor)),
                          ],
                        ),
                      ),

                    // 错误提示
                    if (languageProvider.error != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        color: Colors.orange.withOpacity(0.1),
                        child: Row(
                          children: [
                            const Icon(Icons.warning, color: Colors.orange, size: 16),
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

                    // 搜索框
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

                    // 语言列表
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
                                    child: CircularProgressIndicator(strokeWidth: 2),
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
                            onTap: isSwitching ? null : () {
                              _handleLanguageSwitch(code, name);
                            },
                            // 视觉反馈
                            tileColor: isSelected 
                                ? theme.primaryColor.withOpacity(0.05) 
                                : null,
                            shape: isSelected
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: theme.primaryColor.withOpacity(0.3),
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