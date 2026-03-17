import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ParcelDestinationScreen extends StatelessWidget {
  const ParcelDestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Select Location')),
      body: const Center(
        // TODO: Google Maps + Places autocomplete
        child: Text('Map + Autocomplete here', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
      ),
    );
  }
}
