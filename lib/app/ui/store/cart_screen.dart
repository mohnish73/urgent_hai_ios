import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/store_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _showSheet = false;
  bool _orderDone = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _onCheckout() async {
    final store = context.read<StoreProvider>();
    if (store.cartTotal <= 0) return;

    setState(() {
      _showSheet = true;
      _orderDone = false;
    });

    _timer = Timer(const Duration(milliseconds: 5500), () {
      if (!mounted) return;
      setState(() => _orderDone = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.storeOrderSuccess,
              style: TextStyle(fontFamily: 'Urbanist')),
        ),
      );

      _timer = Timer(const Duration(milliseconds: 2000), () {
        if (!mounted) return;
        store.clearCart();
        context.pushReplacement(AppRoutes.order);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreProvider>(
      builder: (_, store, __) {
        final hasItems = store.cart.isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.lightGrey,
          body: Stack(
            children: [
              // ── Main content ───────────────────────
              SafeArea(
                child: Column(
                  children: [
                    // Header
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
                              AppStrings.storeShoppingCart,
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

                    // Body
                    Expanded(
                      child: !hasItems
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(AppImages.bag, height: 80,
                                      color: AppColors.primary),
                                  const SizedBox(height: 10),
                                  const Text(
                                    AppStrings.storeEmptyCart,
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
                              itemCount: store.cart.length,
                              itemBuilder: (_, i) {
                                final p = store.cart[i];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  color: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(
                                    children: [
                                      // Product image
                                      SizedBox(
                                        width: 70,
                                        height: 80,
                                        child: p.productImageUrl.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: p.productImageUrl,
                                                fit: BoxFit.contain,
                                                errorWidget: (_, __, ___) =>
                                                    Image.asset(AppImages.icGrocery),
                                              )
                                            : Image.asset(AppImages.icGrocery),
                                      ),

                                      // Name / price / unit
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '₹ ${p.price.toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              Text(
                                                p.name,
                                                style: const TextStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              Text(
                                                '${p.quantity} ${p.unit}',
                                                style: const TextStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.gray,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Qty controls
                                      SizedBox(
                                        width: 36,
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () => store.addToCart(p),
                                              child: const Text('+',
                                                  style: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                  )),
                                            ),
                                            const SizedBox(height: 4),
                                            Text('${p.noQty}',
                                                style: const TextStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.black,
                                                )),
                                            const SizedBox(height: 4),
                                            GestureDetector(
                                              onTap: () =>
                                                  store.decreaseFromCart(p.productId),
                                              child: const Text('−',
                                                  style: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    // Total + checkout
                    if (hasItems)
                      Container(
                        color: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            _TotalRow(
                                label: AppStrings.storeSubtotal,
                                value: '₹ ${store.cartSubTotal.toStringAsFixed(0)}',
                                bold: false),
                            const SizedBox(height: 5),
                            _TotalRow(
                                label: AppStrings.storeShipping,
                                value: '₹ 10',
                                bold: false),
                            const Divider(color: AppColors.grey),
                            _TotalRow(
                                label: AppStrings.storeTotal,
                                value: '₹ ${store.cartTotal.toStringAsFixed(0)}',
                                bold: true),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _onCheckout,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  AppStrings.storeCheckout,
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // ── Bottom sheet overlay ────────────────
              if (_showSheet)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: Colors.black45,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 280,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          children: [
                            // Drag handle
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.greyBorder,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            // GIF
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Image.asset(
                                  _orderDone ? AppImages.gifGreenTick : AppImages.gifFood,
                                  key: ValueKey(_orderDone),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _TotalRow({required this.label, required this.value, required this.bold});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold ? AppColors.black : AppColors.gray,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
