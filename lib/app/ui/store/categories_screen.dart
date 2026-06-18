import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';

class _Cat {
  final String name;
  final String image;
  final Color bgColor;
  final String type;
  const _Cat({required this.name, required this.image, required this.bgColor, required this.type});
}

const _allCategories = [
  _Cat(name: 'Grocery',              image: AppImages.icGrocery, bgColor: Color(0xFFF2E8FF), type: 'Retail'),
  _Cat(name: 'Vegetables\n& Fruits', image: AppImages.icVeg,     bgColor: Color(0xFFE6FFF2), type: 'Retail'),
  _Cat(name: 'Food &\nRestaurants',  image: AppImages.icFood,    bgColor: Color(0xFFFFECEC), type: 'Retail'),
  _Cat(name: 'Medicine',             image: AppImages.icMed,     bgColor: Color(0xFFE8F1FF), type: 'Retail'),
  _Cat(name: 'Pet Care',             image: AppImages.icPet,     bgColor: Color(0xFFEFFFFa), type: 'Retail'),
  _Cat(name: 'Sports &\nFitness',    image: AppImages.icSports,  bgColor: Color(0xFFFFF4E5), type: 'Retail'),
  _Cat(name: 'Meat',                 image: AppImages.icMeat,    bgColor: Color(0xFFFFE8E8), type: 'Retail'),
  _Cat(name: 'Laundry',              image: AppImages.icTailor,  bgColor: Color(0xFFF1F5FF), type: 'Custom'),
  _Cat(name: 'Tailor Shop',          image: AppImages.icScissor, bgColor: Color(0xFFE9FFF7), type: 'Custom'),
  _Cat(name: 'Beauty &\nCosmetic',   image: AppImages.icWoman,   bgColor: Color(0xFFFFF0F5), type: 'Custom'),
  _Cat(name: 'Jewellery\nStores',    image: AppImages.icJewel,   bgColor: Color(0xFFFFF7E6), type: 'Custom'),
  _Cat(name: 'Miscellaneous',        image: AppImages.icService, bgColor: Color(0xFFF0F0F0), type: 'Custom'),
];

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _onTap(BuildContext context, _Cat cat) {
    if (cat.type == 'Retail') {
      context.push(AppRoutes.products,
          extra: {'categoryName': cat.name, 'type': 'Retail'});
    } else {
      context.push(AppRoutes.customOrder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Image.asset(AppImages.back, width: 32, height: 32),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    AppStrings.storePickFav,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            // ── 3-col grid ────────────────────────────────
            Expanded(
              child: Container(
                color: AppColors.lightGrey,
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _allCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (_, i) {
                    final cat = _allCategories[i];
                    return GestureDetector(
                      onTap: () => _onTap(context, cat),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: AppColors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                  color: cat.bgColor, shape: BoxShape.circle),
                              child: Center(
                                child: Image.asset(cat.image, width: 28, height: 28),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 11,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
