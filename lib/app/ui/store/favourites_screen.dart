import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/store_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreProvider>(
      builder: (_, store, __) {
        final fav = store.wishlist;

        return Scaffold(
          backgroundColor: AppColors.lightGrey,
          body: SafeArea(
            child: Column(
              children: [
                // ── Header ────────────────────────────────
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Image.asset(AppImages.backBtn, width: 30, height: 30,
                            color: AppColors.black),
                      ),
                      const Expanded(
                        child: Text(
                          AppStrings.storeFavourites,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),

                // ── Content ───────────────────────────────
                Expanded(
                  child: fav.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(AppImages.bag, height: 80,
                                  color: AppColors.primary),
                              const SizedBox(height: 10),
                              const Text(
                                AppStrings.storeEmptyFav,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          itemCount: fav.length,
                          itemBuilder: (_, i) {
                            final p = fav[i];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              color: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Row(
                                children: [
                                  // Image
                                  SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: p.productImageUrl.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: p.productImageUrl,
                                            fit: BoxFit.contain,
                                            errorWidget: (_, __, ___) =>
                                                Image.asset(AppImages.icGrocery),
                                          )
                                        : Image.asset(AppImages.icGrocery),
                                  ),

                                  // Details
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.name,
                                            style: const TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '₹ ${p.price.toStringAsFixed(0)} / ${p.quantity} ${p.unit}',
                                            style: const TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 12,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Remove from wishlist
                                  GestureDetector(
                                    onTap: () => store.toggleWishlist(p),
                                    child: const Icon(Icons.favorite,
                                        color: AppColors.red, size: 24),
                                  ),
                                ],
                              ),
                            );
                          },
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
