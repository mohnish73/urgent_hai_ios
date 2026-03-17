import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';

class StoreHomeTab extends StatelessWidget {
  const StoreHomeTab({super.key});

  // TODO: Replace with API categories
  static const List<Map<String, dynamic>> _categories = [
    {'label': 'Food', 'image': AppImages.icFood},
    {'label': 'Grocery', 'image': AppImages.icGrocery},
    {'label': 'Meat', 'image': AppImages.icMeat},
    {'label': 'Medicine', 'image': AppImages.icMed},
    {'label': 'Pet', 'image': AppImages.icPet},
    {'label': 'Salon', 'image': AppImages.icScissor},
    {'label': 'Services', 'image': AppImages.icService},
    {'label': 'Sports', 'image': AppImages.icSports},
    {'label': 'Tailor', 'image': AppImages.icTailor},
    {'label': 'Veg', 'image': AppImages.icVeg},
    {'label': 'Jewel', 'image': AppImages.icJewel},
    {'label': 'Women', 'image': AppImages.icWoman},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search Bar ───────────────────────────────
            GestureDetector(
              onTap: () => context.push(AppRoutes.products),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.greyBorder),
                ),
                child: Row(
                  children: [
                    Image.asset(AppImages.search, width: 20, height: 20, color: AppColors.gray),
                    const SizedBox(width: 8),
                    const Text('Search products...', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.textHint)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Banner ───────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(AppImages.bannerFood, width: double.infinity, height: 150, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),

            // ── Categories ───────────────────────────────
            const Text('Categories', style: TextStyle(fontFamily: 'Urbanist', fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, i) {
                final cat = _categories[i];
                return GestureDetector(
                  onTap: () => context.push(AppRoutes.products),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                        child: Image.asset(cat['image'] as String, width: 36, height: 36, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 4),
                      Text(cat['label'] as String, style: const TextStyle(fontFamily: 'Urbanist', fontSize: 11), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // ── Offers ───────────────────────────────────
            Row(
              children: [
                const Text('Offers', style: TextStyle(fontFamily: 'Urbanist', fontSize: 18, fontWeight: FontWeight.w700)),
                const Spacer(),
                Image.asset(AppImages.viewMore, width: 18, height: 18),
                const SizedBox(width: 4),
                const Text('View All', style: TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(AppImages.slider2, height: 100, fit: BoxFit.cover))),
                const SizedBox(width: 10),
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(AppImages.slider3, height: 100, fit: BoxFit.cover))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
