import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ParcelDetailsScreen extends StatelessWidget {
  const ParcelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(title: const Text('Parcel Tracking')),
      body: const Center(
        // TODO: Show parcel status, sender/receiver info, cancel option
        child: Text('Parcel tracking details here', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
      ),
    );
  }
}
