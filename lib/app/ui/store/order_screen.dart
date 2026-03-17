import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../utils/custom_app_button.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Place Order')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImages.gifDelivery, width: 160, height: 160),
                  const SizedBox(height: 16),
                  // TODO: Show order summary, address selection, total
                  const Text('Order summary here', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomAppButton(
              title: 'Confirm Order',
              onPressed: () {
                // TODO: call order API
              },
            ),
          ),
        ],
      ),
    );
  }
}
