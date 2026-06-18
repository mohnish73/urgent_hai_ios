import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────
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
                    AppStrings.storeTrackOrder,
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

            Expanded(
              child: Container(
                color: AppColors.lightGrey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ── Order summary card ─────────────
                      Container(
                        margin: const EdgeInsets.all(10),
                        color: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEBFFD7),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Image.asset(AppImages.order1,
                                    width: 35, height: 35),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Order #98765',
                                      style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    Text(
                                      '10 Feb 2026',
                                      style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Items: 10',
                                          style: TextStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Total: ₹ 220',
                                          style: TextStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Order tracking steps ───────────
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        color: AppColors.white,
                        child: Column(
                          children: const [
                            _TrackStep(
                              image: AppImages.order2,
                              label: 'Order Placed',
                              date: '10 Feb 2026',
                              hasDivider: true,
                              bgColor: Color(0xFFEBFFD7),
                            ),
                            _TrackStep(
                              image: AppImages.order3,
                              label: 'Preparing / Packed',
                              date: '10 Feb 2026',
                              hasDivider: true,
                              bgColor: Color(0xFFEBFFD7),
                            ),
                            _TrackStep(
                              image: AppImages.order4,
                              label: 'Ready For Pickup',
                              date: '10 Feb 2026',
                              hasDivider: true,
                              bgColor: Color(0xFFEBFFD7),
                            ),
                            _TrackStep(
                              image: AppImages.order5,
                              label: 'Out For Delivery',
                              date: '10 Feb 2026',
                              hasDivider: true,
                              bgColor: AppColors.lightGrey,
                            ),
                            _TrackStep(
                              image: AppImages.order6,
                              label: 'Delivered',
                              date: '10 Feb 2026',
                              hasDivider: false,
                              bgColor: AppColors.lightGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackStep extends StatelessWidget {
  final String image;
  final String label;
  final String date;
  final bool hasDivider;
  final Color bgColor;

  const _TrackStep({
    required this.image,
    required this.label,
    required this.date,
    required this.hasDivider,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Center(
                  child: Image.asset(image, width: 35, height: 35),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasDivider)
          Container(
            margin: const EdgeInsets.only(left: 90),
            height: 1,
            color: AppColors.lightGrey,
          ),
      ],
    );
  }
}
