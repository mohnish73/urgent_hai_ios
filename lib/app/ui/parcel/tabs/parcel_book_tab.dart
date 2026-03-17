import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/custom_app_button.dart';

class ParcelBookTab extends StatelessWidget {
  const ParcelBookTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send a Parcel', style: TextStyle(fontFamily: 'Urbanist', fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => context.push(AppRoutes.parcelDestination),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  children: [
                    Icon(Icons.my_location, color: AppColors.primary),
                    SizedBox(width: 12),
                    Text('Pickup Location', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.textHint)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => context.push(AppRoutes.parcelDestination),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: AppColors.red),
                    SizedBox(width: 12),
                    Text('Drop Location', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.textHint)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            CustomAppButton(
              title: 'Continue',
              onPressed: () => context.push(AppRoutes.bookParcel),
            ),
          ],
        ),
      ),
    );
  }
}
