import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../network/Get/models/splash_page/login_area.dart';
import '../../../network/Get/services/splash_page/login_area.dart';

class CountrySelectWidget extends StatefulWidget {
  final ValueChanged<Country> onSelected;

  const CountrySelectWidget({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<CountrySelectWidget> createState() => _CountrySelectWidgetState();
}

class _CountrySelectWidgetState extends State<CountrySelectWidget> {
  List<Country> _countries = [];
  Country? _selectedCountry;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  void _loadCountries() async {
    try {
      final countries = await fetchCountries();
      final defaultCountry = countries.firstWhere(
        (c) => c.isDefault,
        orElse: () => countries[0],
      );
      setState(() {
        _countries = countries;
        _selectedCountry = defaultCountry;
        _isLoading = false;
      });

      widget.onSelected(defaultCountry);
    } catch (e) {
      print("国家区号加载失败: $e");
      if(mounted){
      setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    return DropdownButton<Country>(
  value: _selectedCountry,
  isExpanded: true,
  underline: SizedBox(),
  dropdownColor: Colors.white, // ✅ 固定下拉背景色为白色
  onChanged: (Country? newValue) {
    setState(() => _selectedCountry = newValue);
    if (newValue != null) {
      widget.onSelected(newValue);
    }
  },
  items: _countries.map((Country country) {
    return DropdownMenuItem<Country>(
      value: country,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 20,
            color: Colors.white, // 图片背景固定白色
            child: CachedNetworkImage(
              imageUrl: country.iconUrl,
              width: 40,
              height: 20,
              fit: BoxFit.contain,
              placeholder: (_, __) => Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
              ),
              errorWidget: (_, __, ___) => Icon(Icons.error, size: 20),
            ),
          ),
          SizedBox(width: 6),
          Text(
            '+${country.areaCode}',
           style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }).toList(),
);
  }
}
