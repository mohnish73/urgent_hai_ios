import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../utils/custom_app_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(title: const Text('My Cart')),
      body: Column(
        children: [
          Expanded(
            // TODO: Load cart items from SharedPreferences
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImages.bag, width: 100, height: 100),
                  const SizedBox(height: 12),
                  const Text('Your cart is empty', style: TextStyle(fontFamily: 'Urbanist', fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('Add items to get started', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomAppButton(
              title: 'Proceed to Order',
              onPressed: () => context.push(AppRoutes.order),
            ),
          ),
        ],
      ),
    );
  }
}
