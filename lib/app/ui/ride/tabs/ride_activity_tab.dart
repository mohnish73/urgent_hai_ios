import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';

class RideActivityTab extends StatelessWidget {
  const RideActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // TODO: Load ride history list from API
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.gifRide, width: 180, height: 180),
          const SizedBox(height: 12),
          const Text('No ride history yet.', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray, fontSize: 16)),
        ],
      ),
    );
  }
}
