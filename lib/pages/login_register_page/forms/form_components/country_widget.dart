import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../network/Get/models/splash_page/login_area.dart';
import '../../../../providers/countries/countries.dart';

class CountrySelectWidget extends StatelessWidget {
  final ValueChanged<Country> onSelected;

  const CountrySelectWidget({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countryProvider = context.watch<CountryProvider>();

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
      icon: const SizedBox.shrink(),
      onChanged: (Country? newValue) {
        if (newValue != null) {
          countryProvider.selectCountry(newValue);
          onSelected(newValue);
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
              const SizedBox(width: 8),
              Text('+${country.areaCode}', style: const TextStyle(color: Colors.black)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
