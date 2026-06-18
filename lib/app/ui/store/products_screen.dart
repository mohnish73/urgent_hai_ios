import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../model/store/product_model.dart';
import '../../provider/store_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';

class ProductsScreen extends StatefulWidget {
  final String categoryName;
  final String type;

  const ProductsScreen({super.key, required this.categoryName, required this.type});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchCtrl = TextEditingController();
  bool _showVeg = false;
  bool _fabOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ProductData> _filtered(List<ProductData> all) {
    var list = all.where((p) => p.isAvailable).toList();
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) list = list.where((p) => p.name.toLowerCase().contains(q)).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Consumer<StoreProvider>(
        builder: (_, store, __) {
          final filtered = store.products.isSuccess && store.products.data != null
              ? _filtered(store.products.data!)
              : <ProductData>[];

          return Stack(
            children: [
              NestedScrollView(
                headerSliverBuilder: (_, __) => [
                  // ── Search app bar ───────────────────
                  SliverAppBar(
                    backgroundColor: AppColors.white,
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    titleSpacing: 10,
                    title: Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.greyBorder, width: 0.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Image.asset(AppImages.back, width: 24, height: 24),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.search, color: AppColors.gray, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                hintText: AppStrings.storeEnterSearch,
                                hintStyle: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 14,
                                  color: AppColors.gray,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                body: Column(
                  children: [
                    // ── Veg/Non-Veg toggle filter ─────
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _showVeg = !_showVeg),
                            child: Container(
                              width: 28,
                              height: 28,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                color: _showVeg ? AppColors.primary : AppColors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 2),
                              ),
                              child: _showVeg
                                  ? const Icon(Icons.check, color: AppColors.white, size: 16)
                                  : null,
                            ),
                          ),
                          Text(
                            _showVeg ? AppStrings.storeNonVeg : AppStrings.storeVeg,
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Food banner ────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(AppImages.bannerFood,
                            width: double.infinity, fit: BoxFit.fitWidth),
                      ),
                    ),

                    // ── Products grid ──────────────────
                    Expanded(
                      child: store.products.isLoading
                          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                          : filtered.isEmpty
                              ? Center(
                                  child: Text(
                                    store.products.isError
                                        ? (store.products.message ?? 'Failed to load products')
                                        : AppStrings.storeNoProductFound,
                                    style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.black,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: filtered.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 0.68,
                                  ),
                                  itemBuilder: (_, i) => _ProductCard(product: filtered[i]),
                                ),
                    ),
                  ],
                ),
              ),

              // ── FAB cluster ────────────────────────
              Positioned(
                bottom: 16,
                right: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Sub-FABs
                    AnimatedOpacity(
                      opacity: _fabOpen ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Favourites
                          GestureDetector(
                            onTap: _fabOpen
                                ? () {
                                    setState(() => _fabOpen = false);
                                    context.push(AppRoutes.favourites);
                                  }
                                : null,
                            child: Container(
                              width: 44,
                              height: 44,
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: const BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite, color: AppColors.white, size: 20),
                            ),
                          ),
                          // Cart
                          GestureDetector(
                            onTap: _fabOpen
                                ? () {
                                    setState(() => _fabOpen = false);
                                    context.push(AppRoutes.cart);
                                  }
                                : null,
                            child: Container(
                              width: 44,
                              height: 44,
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFC107),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.shopping_bag, color: AppColors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main FAB
                    GestureDetector(
                      onTap: () => setState(() => _fabOpen = !_fabOpen),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: AnimatedRotation(
                            turns: _fabOpen ? 0.125 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Image.asset(
                              _fabOpen ? AppImages.icCart : AppImages.icCart,
                              width: 24,
                              height: 24,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Product card ──────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final ProductData product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreProvider>(
      builder: (_, store, __) {
        final inCart = store.isInCart(product.productId);
        final qty = store.getCartQty(product.productId);
        final inWishlist = store.isInWishlist(product.productId);

        return GestureDetector(
          onTap: () => context.push(AppRoutes.productDetail,
              extra: {'product': product}),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image + wishlist toggle
                  SizedBox(
                    height: 80,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: product.productImageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: product.productImageUrl,
                                  fit: BoxFit.contain,
                                  errorWidget: (_, __, ___) => Image.asset(
                                      AppImages.icGrocery, fit: BoxFit.contain),
                                )
                              : Image.asset(AppImages.icGrocery, fit: BoxFit.contain),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => store.toggleWishlist(product),
                            child: Icon(
                              inWishlist ? Icons.favorite : Icons.favorite_border,
                              color: inWishlist ? AppColors.red : AppColors.gray,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Name
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),

                  // Price / unit
                  Row(
                    children: [
                      Text(
                        '₹ ${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                      const Text(' / ', style: TextStyle(
                          fontFamily: 'Urbanist', fontSize: 12, color: AppColors.primary)),
                      Text(
                        '${product.quantity} ${product.unit}',
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Add to cart / qty controls
                  if (!inCart)
                    GestureDetector(
                      onTap: () => store.addToCart(product),
                      child: Row(
                        children: [
                          Image.asset(AppImages.bagMini, width: 14, height: 14,
                              color: AppColors.black),
                          const SizedBox(width: 5),
                          const Text(
                            AppStrings.storeAddToCart,
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => store.decreaseFromCart(product.productId),
                          child: const Text(
                            '−',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Text(
                          '$qty',
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => store.addToCart(product),
                          child: const Text(
                            '+',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
