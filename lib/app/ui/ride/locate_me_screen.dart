import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class LocateMeScreen extends StatelessWidget {
  const LocateMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Locate Me')),
      body: const Center(
        // TODO: Google Maps with current location pin + confirm button
        child: Text('Map with current location here', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
      ),
    );
  }
}
