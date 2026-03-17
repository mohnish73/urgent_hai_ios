import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // TODO: Load order history from API
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.gifNoDataFound, width: 180, height: 180),
          const SizedBox(height: 12),
          const Text('No orders yet.', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray, fontSize: 16)),
        ],
      ),
    );
  }
}
