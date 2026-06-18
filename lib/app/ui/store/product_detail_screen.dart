import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../model/store/product_model.dart';
import '../../provider/store_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductData product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreProvider>(
      builder: (_, store, __) {
        final inCart = store.isInCart(product.productId);
        final qty = store.getCartQty(product.productId);
        final inWishlist = store.isInWishlist(product.productId);

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                // ── Header ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Image.asset(AppImages.back, width: 32, height: 32),
                      ),
                    ],
                  ),
                ),

                // ── Body (2 halves) ───────────────────────
                Expanded(
                  child: Column(
                    children: [
                      // Top half: image
                      Expanded(
                        flex: 8,
                        child: Container(
                          color: AppColors.white,
                          padding: const EdgeInsets.all(20),
                          child: product.productImageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: product.productImageUrl,
                                  fit: BoxFit.contain,
                                  errorWidget: (_, __, ___) => Image.asset(
                                      AppImages.icGrocery,
                                      fit: BoxFit.contain),
                                )
                              : Image.asset(AppImages.icGrocery, fit: BoxFit.contain),
                        ),
                      ),

                      // Bottom half: details
                      Expanded(
                        flex: 12,
                        child: Container(
                          color: AppColors.lightGrey,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Price + wishlist
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '₹ ${product.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => store.toggleWishlist(product),
                                    child: Icon(
                                      inWishlist ? Icons.favorite : Icons.favorite_border,
                                      color: inWishlist ? AppColors.red : AppColors.gray,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),

                              // Name
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                ),
                              ),

                              // Qty + unit
                              Text(
                                '${product.quantity} ${product.unit}',
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.gray,
                                ),
                              ),

                              const Spacer(),

                              // Add to Cart / qty controls
                              SizedBox(
                                height: 50,
                                child: !inCart
                                    ? GestureDetector(
                                        onTap: () => store.addToCart(product),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(AppImages.bag, width: 20, height: 20,
                                                  color: AppColors.white),
                                              const SizedBox(width: 8),
                                              const Text(
                                                AppStrings.storeAddToCart,
                                                style: TextStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(color: AppColors.greyBorder),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              flex: 2,
                                              child: Text(
                                                AppStrings.storeQuantity,
                                                style: TextStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 14,
                                                  color: AppColors.gray,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () => store.decreaseFromCart(product.productId),
                                                child: const Center(
                                                  child: Text(
                                                    '−',
                                                    style: TextStyle(
                                                      fontFamily: 'Urbanist',
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                                width: 1,
                                                height: 30,
                                                color: AppColors.grey),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  '$qty',
                                                  style: const TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                                width: 1,
                                                height: 30,
                                                color: AppColors.grey),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (qty < 5) {
                                                    store.addToCart(product);
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Max. limit reached',
                                                            style: TextStyle(fontFamily: 'Urbanist')),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: const Center(
                                                  child: Text(
                                                    '+',
                                                    style: TextStyle(
                                                      fontFamily: 'Urbanist',
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
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
