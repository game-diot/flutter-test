import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language/language.dart';
import 'widgets/compact_reset_to_chinese_button.dart';
import 'widgets/language_search_bar.dart';
import 'widgets/language_loading_banner.dart';
import 'widgets/language_error_banner.dart';
import 'widgets/language_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

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
      final cached = await Provider.of<LanguageProvider>(
        context,
        listen: false,
      ).loadLanguageListCache();
      if (cached != null && cached.isNotEmpty) {
        setState(() {
          _languages = cached;
          _filteredLanguages = _languages;
          _loading = false;
        });
      }

      final response = await http.get(
        Uri.parse(
          'https://us14-h5.yanshi.lol/api/app-api/system/i18n-type/list',
        ),
      );
      final result = json.decode(response.body);
      if (result['code'] == 0) {
        final data = result['data'];
        setState(() {
          _languages = data;
          _filteredLanguages = _languages;
          _loading = false;
        });
        await Provider.of<LanguageProvider>(
          context,
          listen: false,
        ).saveLanguageListCache(data);
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('加载语言列表失败: $e')));
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

    if (_switchingLanguage == code || languageProvider.currentCode == code)
      return;

    setState(() => _switchingLanguage = code);

    try {
      await languageProvider.setLanguage(code, name);
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _switchingLanguage = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
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
            actions: const [CompactResetToChineseButton()],
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (languageProvider.isLoading)
                      LanguageLoadingBanner(color: theme.primaryColor),
                    if (languageProvider.error != null)
                      LanguageErrorBanner(
                        error: languageProvider.error!,
                        onRetry: languageProvider.retryLoadTranslations,
                      ),
                    LanguageSearchBar(onChanged: _filterLanguages),
                    Expanded(
                      child: LanguageList(
                        languages: _filteredLanguages,
                        currentCode: languageProvider.currentCode,
                        switchingCode: _switchingLanguage,
                        onSwitch: _handleLanguageSwitch,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
