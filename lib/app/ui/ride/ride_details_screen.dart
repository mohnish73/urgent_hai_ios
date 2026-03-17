import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(title: const Text('Ride Details')),
      body: const Center(
        // TODO: Show booking status, driver details, payment info
        child: Text('Ride details & tracking here', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
      ),
    );
  }
}
