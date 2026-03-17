import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';

class ParcelActivityTab extends StatelessWidget {
  const ParcelActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // TODO: Load parcel history from API
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.gifDelivery, width: 180, height: 180),
          const SizedBox(height: 12),
          const Text('No parcel history yet.', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray, fontSize: 16)),
        ],
      ),
    );
  }
}
