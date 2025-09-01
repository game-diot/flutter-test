import 'local_translations.dart';
import 'i18n_service.dart';

class Lang {
  static String currentLang = 'zh';
  static final _defaultChinese = Map<String, String>.from(LocalTranslations.zh);
  static final Map<String, Map<String, String>> _translations = {
    'zh': Map.from(LocalTranslations.zh),
    'en': Map.from(LocalTranslations.en),
  };
  static Map<String, String> getTranslations(String lang) {
    return Map<String, String>.from(_translations[lang] ?? {});
  }

  static void resetToDefaultChinese() {
    currentLang = 'zh';
    _translations['zh'] = Map.from(_defaultChinese);
  }

  static String t(String key, {Map<String, String>? params}) {
    String text =
        _translations[currentLang]?[key] ?? _defaultChinese[key] ?? key;
    if (params != null)
      params.forEach((k, v) => text = text.replaceAll('{$k}', v));
    return text;
  }

  static void overrideTranslations(String lang, Map<String, String> data) {
    _translations.putIfAbsent(lang, () => {});
    _translations[lang]!.addAll(data);
  }

  static Future<bool> loadRemoteTranslations(String lang) async {
    final remote = await I18nService.loadTranslations(lang);
    if (remote != null) {
      mergeTranslations(lang, remote);
      currentLang = lang;
      return true;
    }
    return false;
  }

  static void mergeTranslations(String lang, Map<String, String> data) {
    _translations.putIfAbsent(lang, () => {});
    _translations[lang]!.addAll(data);
  }

  static Future<void> preloadLanguages(List<String> languages) async {
    for (final lang in languages) {
      if (_translations.containsKey(lang) && _translations[lang]!.isNotEmpty)
        continue;
      final remote = await I18nService.loadTranslations(lang);
      if (remote != null) mergeTranslations(lang, remote);
    }
  }

  static Map<String, int> getTranslationStats() {
    final stats = <String, int>{};
    _translations.forEach((lang, map) => stats[lang] = map.length);
    return stats;
  }

  static void debugPrintStats() {
    getTranslationStats().forEach(
      (lang, count) => print('[Lang] $lang: $count keys'),
    );
  }

  static bool validateTranslations() {
    bool valid = true;
    _translations.forEach((lang, map) {
      map.forEach((k, v) {
        if (v.isEmpty) {
          print('[Lang] Warning: empty value for "$k" in $lang');
          valid = false;
        }
      });
    });
    return valid;
  }

  static bool hasValidTranslations(String lang) {
    final map = _translations[lang];
    if (map == null || map.isEmpty) return false;
    return !map.values.any((v) => v.isEmpty);
  }

  static List<String> getSupportedLanguages() => _translations.keys.toList();

  static Future<void> clearCache(String lang) => I18nService.clearCache(lang);
  static Future<void> clearAllCache() => I18nService.clearAllCache();
}
