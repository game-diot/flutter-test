import 'package:flutter/material.dart';
import '../../../../../network/Get/models/splash_page/login_area.dart';
import '../../../../../network/Get/services/splash_page/login_area.dart';

class CountryProvider with ChangeNotifier {
  List<Country> _countries = [];
  Country? _selectedCountry;
  bool _isLoading = false;

  List<Country> get countries => _countries;
  Country? get selectedCountry => _selectedCountry;
  bool get isLoading => _isLoading;

  Future<void> loadCountries() async {
    if (_countries.isNotEmpty) return; 
    _isLoading = true;
    notifyListeners();

    try {
      final countries = await fetchCountries();
      _countries = countries;
      _selectedCountry = countries.firstWhere(
        (c) => c.isDefault,
        orElse: () => countries[0],
      );
    } catch (e) {
      print("国家区号加载失败: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCountry(Country country) {
    _selectedCountry = country;
    notifyListeners();
  }
}
