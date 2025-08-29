import 'package:flutter/material.dart';
import '../../../../../network/Get/models/splash_page/login_area.dart';
import '../../../../../network/Get/services/splash_page/login_area.dart';

/// Provider: 管理国家列表、选中国家及加载状态
class CountryProvider with ChangeNotifier {
  /// 国家列表
  List<Country> _countries = [];

  /// 当前选中国家
  Country? _selectedCountry;

  /// 是否正在加载
  bool _isLoading = false;

  /// Getter
  List<Country> get countries => _countries;
  Country? get selectedCountry => _selectedCountry;
  bool get isLoading => _isLoading;

  /// 加载国家列表（App启动时调用）
  Future<void> loadCountries() async {
    // 避免重复请求
    if (_countries.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // 发起网络请求获取国家列表
      final countries = await fetchCountries();

      _countries = countries;

      // 设置默认选中国家
      _selectedCountry = countries.isNotEmpty
          ? countries.firstWhere((c) => c.isDefault, orElse: () => countries[0])
          : null;

      print("国家列表加载成功: ${_countries.length} 个国家");
    } catch (e) {
      print("国家区号加载失败: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 手动选择国家
  void selectCountry(Country country) {
    _selectedCountry = country;
    notifyListeners();
  }

  /// 重置国家数据（可选）
  Future<void> resetCountries() async {
    _countries = [];
    _selectedCountry = null;
    notifyListeners();
    await loadCountries();
  }
}
