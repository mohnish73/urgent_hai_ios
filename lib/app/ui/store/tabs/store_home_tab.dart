import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/services/location_service.dart';
import '../../../provider/store_provider.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';
import '../../../theme/app_strings.dart';

class _Cat {
  final String name;
  final String image;
  final Color bgColor;
  final String type;
  const _Cat({required this.name, required this.image, required this.bgColor, required this.type});
}

const _miniCategories = [
  _Cat(name: 'Grocery',             image: AppImages.icGrocery, bgColor: Color(0xFFF2E8FF), type: 'Retail'),
  _Cat(name: 'Vegetables\n& Fruits',image: AppImages.icVeg,     bgColor: Color(0xFFE6FFF2), type: 'Retail'),
  _Cat(name: 'Food &\nRestaurants', image: AppImages.icFood,    bgColor: Color(0xFFFFECEC), type: 'Retail'),
  _Cat(name: 'Medicine',            image: AppImages.icMed,     bgColor: Color(0xFFE8F1FF), type: 'Retail'),
  _Cat(name: 'Pet Care',            image: AppImages.icPet,     bgColor: Color(0xFFEFFFFa), type: 'Retail'),
  _Cat(name: 'Sports &\nFitness',   image: AppImages.icSports,  bgColor: Color(0xFFFFF4E5), type: 'Retail'),
  _Cat(name: 'Meat',                image: AppImages.icMeat,    bgColor: Color(0xFFFFE8E8), type: 'Retail'),
  _Cat(name: 'Laundry',             image: AppImages.icTailor,  bgColor: Color(0xFFF1F5FF), type: 'Custom'),
];

class StoreHomeTab extends StatefulWidget {
  const StoreHomeTab({super.key});

  @override
  State<StoreHomeTab> createState() => _StoreHomeTabState();
}

class _StoreHomeTabState extends State<StoreHomeTab> {
  String _locCity = '';
  String _locCountry = AppStrings.defaultCountry;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final result = await LocationService.fetchCurrentLocation();
    if (result != null && mounted) {
      setState(() {
        _locCity = result.city;
        _locCountry = result.country;
      });
    }
  }

  void _onCategoryTap(_Cat cat) {
    if (cat.type == 'Retail') {
      context.push(AppRoutes.products,
          extra: {'categoryName': cat.name, 'type': 'Retail'});
    } else {
      context.push(AppRoutes.customOrder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreProvider>(
      builder: (_, store, __) {
        final hasCart = store.cartItemCount > 0;
        final hasFav = store.wishlist.isNotEmpty;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Location row ────────────────────────────────
                GestureDetector(
                  onTap: _loadLocation,
                  child: Row(
                    children: [
                      Image.asset(AppImages.location, width: 24, height: 24),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _locCity.isNotEmpty ? _locCity : AppStrings.defaultCountry,
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            if (_locCity.isNotEmpty)
                              Text(
                                _locCountry,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ── Search bar ──────────────────────────────────
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.greyBorder, width: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Image.asset(AppImages.search, width: 18, height: 18,
                          color: AppColors.gray),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: AppStrings.storeSearch,
                            hintStyle: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              color: AppColors.gray,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                          ),
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ── Ad banners ──────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(AppImages.offer, height: 100, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(AppImages.discounts, height: 100, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // ── Continue cart banner ────────────────────────
                if (hasCart)
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.cart),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Image.asset(AppImages.bagMini, width: 18, height: 18,
                              color: AppColors.primary),
                          const SizedBox(width: 5),
                          const Expanded(
                            child: Text(
                              AppStrings.storeContinueCart,
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              '${store.cartItemCount}',
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // ── Shop By Category header ─────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.storeShopByCategory,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.categories),
                      child: const Text(
                        AppStrings.storeSeeAll,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // ── Mini category grid (4-col, 8 items) ─────────
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _miniCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 6,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (_, i) => _MiniCategoryItem(
                    cat: _miniCategories[i],
                    onTap: () => _onCategoryTap(_miniCategories[i]),
                  ),
                ),

                const SizedBox(height: 5),

                // ── Food banner ─────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(AppImages.bannerFood,
                      width: double.infinity, fit: BoxFit.fitWidth),
                ),

                const SizedBox(height: 10),

                // ── Favourites ──────────────────────────────────
                const Text(
                  AppStrings.storeFavourites,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 5),

                if (hasFav)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: store.wishlist.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 6,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (_, i) {
                      final p = store.wishlist[i];
                      return _MiniCategoryItem(
                        cat: _Cat(
                          name: p.name,
                          image: AppImages.icGrocery,
                          bgColor: const Color(0xFFE6FFF2),
                          type: 'Retail',
                        ),
                        onTap: () => context.push(AppRoutes.products,
                            extra: {'categoryName': p.name, 'type': 'Retail'}),
                      );
                    },
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppStrings.storeNoFav,
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // ── Footer ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        AppStrings.storeFooterTitle,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey,
                        ),
                      ),
                      Text(
                        AppStrings.storeFooterTagline,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 22,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MiniCategoryItem extends StatelessWidget {
  final _Cat cat;
  final VoidCallback onTap;
  const _MiniCategoryItem({required this.cat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: cat.bgColor, shape: BoxShape.circle),
            child: Center(
              child: Image.asset(cat.image, width: 28, height: 28),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cat.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 10,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
