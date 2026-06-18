import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Upcoming ─────────────────────────────────
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 8),
            child: Text(
              'Upcoming',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),

          _OrderCard(
            storeName: 'Xero Degrees',
            items: '1 X Nutella Caramel\n1 X Virgin Mojito Cooler',
            amount: '₹ 149',
            dateTime: '2 Apr 2025, 4:00 PM',
            isActive: true,
          ),

          // ── Past ─────────────────────────────────────
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'Past',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),

          _OrderCard(
            storeName: 'Xero Degrees',
            items: '1 X Nutella Caramel\n1 X Virgin Mojito Cooler\n1 X Nutella Caramel\n1 X Virgin Mojito Cooler',
            amount: '₹ 580',
            dateTime: '2 Apr 2025, 4:00 PM',
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String storeName;
  final String items;
  final String amount;
  final String dateTime;
  final bool isActive;

  const _OrderCard({
    required this.storeName,
    required this.items,
    required this.amount,
    required this.dateTime,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store name + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storeName,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                Row(
                  children: [
                    if (isActive)
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      isActive ? 'Active' : 'Delivered',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isActive ? AppColors.primary : AppColors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 5),

            // Items + amount
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    items,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Text(
                  amount,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            // Date
            Text(
              dateTime,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
