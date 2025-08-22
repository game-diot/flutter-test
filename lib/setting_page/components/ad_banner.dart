import 'package:flutter/material.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({super.key}); // ✅ 支持 const
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/ad_banner.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
