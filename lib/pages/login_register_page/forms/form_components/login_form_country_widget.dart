import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../network/Get/models/splash_page/login_area.dart';
import '../../../../providers/countries/countries.dart';
class CountrySelectWidget extends StatefulWidget {
  final ValueChanged<Country> onSelected;

  const CountrySelectWidget({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<CountrySelectWidget> createState() => _CountrySelectWidgetState();
}

class _CountrySelectWidgetState extends State<CountrySelectWidget> {
  bool _hasRequested = false;

  @override
  Widget build(BuildContext context) {
    final countryProvider = context.watch<CountryProvider>();


    if (!_hasRequested && countryProvider.countries.isEmpty && !countryProvider.isLoading) {
      _hasRequested = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CountryProvider>().loadCountries();
      });
    }

    if (countryProvider.isLoading) {
      return const CircularProgressIndicator();
    }

    final selectedCountry = countryProvider.selectedCountry;
    final countries = countryProvider.countries;

    return DropdownButton<Country>(
      value: selectedCountry,
      isExpanded: true,
      underline: const SizedBox(),
      dropdownColor: Colors.white,
        icon: const SizedBox.shrink(), // 👈 去掉默认的箭头
      onChanged: (Country? newValue) {
        if (newValue != null) {
          context.read<CountryProvider>().selectCountry(newValue);
          widget.onSelected(newValue);
        }
      },
      items: countries.map((country) {
        return DropdownMenuItem<Country>(
          value: country,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 20,
                color: Colors.white,
                child: CachedNetworkImage(
                  imageUrl: country.iconUrl,
                  width: 40,
                  height: 20,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                  errorWidget: (_, __, ___) => const Icon(Icons.error, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Text('+${country.areaCode}', style: const TextStyle(color: Colors.black)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
