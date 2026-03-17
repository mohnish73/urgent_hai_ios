import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          GestureDetector(
            onTap: () => context.push(AppRoutes.cart),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Image.asset(AppImages.icCart, width: 26, height: 26),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75,
        ),
        // TODO: Load products from API
        itemCount: 8,
        itemBuilder: (context, i) {
          final sampleImages = [AppImages.sample1Meal, AppImages.sample2Meal, AppImages.sample4Meal, AppImages.samplePic];
          return GestureDetector(
            onTap: () => context.push(AppRoutes.productDetail),
            child: Container(
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(sampleImages[i % sampleImages.length], width: double.infinity, fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Product Name', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text('₹99', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.primary, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 6),
                            const Text('₹149', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray, fontSize: 11, decoration: TextDecoration.lineThrough)),
                            const Spacer(),
                            Image.asset(AppImages.icPlus, width: 20, height: 20, color: AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
