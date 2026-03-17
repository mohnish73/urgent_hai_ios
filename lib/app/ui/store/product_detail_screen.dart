import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../utils/custom_app_button.dart';
import '../../utils/widgets/heart_toggle.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLiked = false;
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Product Detail'),
        actions: [
          HeartToggle(isLiked: _isLiked, onTap: () => setState(() => _isLiked = !_isLiked)),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () => context.push(AppRoutes.cart)),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image carousel
                  Container(
                    height: 260,
                    color: AppColors.lightGrey,
                    child: const Center(
                      // TODO: Replace with carousel_slider + cached images
                      child: Icon(Icons.image_outlined, size: 64, color: AppColors.gray),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Product Name', style: TextStyle(fontFamily: 'Urbanist', fontSize: 22, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('₹99', style: TextStyle(fontFamily: 'Urbanist', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            const SizedBox(width: 8),
                            const Text('₹149', style: TextStyle(fontFamily: 'Urbanist', fontSize: 14, color: AppColors.gray, decoration: TextDecoration.lineThrough)),
                            const Spacer(),
                            const Text('1 kg', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Quantity selector
                        Row(
                          children: [
                            const Text('Quantity', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600)),
                            const Spacer(),
                            _QtyButton(icon: Icons.remove, onTap: () { if (_qty > 1) setState(() => _qty--); }),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('$_qty', style: const TextStyle(fontFamily: 'Urbanist', fontSize: 16, fontWeight: FontWeight.w700)),
                            ),
                            _QtyButton(icon: Icons.add, onTap: () => setState(() => _qty++)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('Description', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 8),
                        const Text(
                          'Product description goes here. TODO: Load from API.',
                          style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomAppButton(
              title: 'Add to Cart',
              onPressed: () {
                // TODO: Add to cart (SharedPreferences)
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
