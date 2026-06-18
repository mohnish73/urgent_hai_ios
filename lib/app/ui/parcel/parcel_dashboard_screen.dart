import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import 'tabs/parcel_book_tab.dart';
import 'tabs/parcel_activity_tab.dart';

class ParcelDashboardScreen extends StatefulWidget {
  const ParcelDashboardScreen({super.key});

  @override
  State<ParcelDashboardScreen> createState() => _ParcelDashboardScreenState();
}

class _ParcelDashboardScreenState extends State<ParcelDashboardScreen> {
  int _currentIndex = 0; // 0 = Send Parcel, 1 = Activity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Content area ──────────────────────────────────
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: const [ParcelBookTab(), ParcelActivityTab()],
              ),
            ),

            // ── Bottom navigation bar ─────────────────────────
            // Matches activity_dashboard_parcel.xml exactly:
            // [Home button 40%] [BottomNavigationView 60%]
            Container(
              height: 55,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.greyBorder, width: 0.5)),
              ),
              child: Row(
                children: [
                  // ── Home button (light_green bg) ──────────────
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        color: AppColors.lightGreen,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.backBtn,
                              width: 18,
                              height: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Home',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Send Parcel tab ───────────────────────────
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => setState(() => _currentIndex = 0),
                      child: Container(
                        color: AppColors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.parcel,
                              width: 22,
                              height: 22,
                              color: _currentIndex == 0
                                  ? AppColors.primary
                                  : AppColors.gray,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Parcel',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _currentIndex == 0
                                    ? AppColors.primary
                                    : AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Activity tab ──────────────────────────────
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => setState(() => _currentIndex = 1),
                      child: Container(
                        color: AppColors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.activity,
                              width: 22,
                              height: 22,
                              color: _currentIndex == 1
                                  ? AppColors.primary
                                  : AppColors.gray,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Activity',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _currentIndex == 1
                                    ? AppColors.primary
                                    : AppColors.gray,
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
          ],
        ),
      ),
    );
  }
}
