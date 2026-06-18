import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import 'tabs/orders_tab.dart';
import 'tabs/store_home_tab.dart';

class StoreDashboardScreen extends StatefulWidget {
  const StoreDashboardScreen({super.key});

  @override
  State<StoreDashboardScreen> createState() => _StoreDashboardScreenState();
}

class _StoreDashboardScreenState extends State<StoreDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: const [StoreHomeTab(), OrdersTab()],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 55,
      color: AppColors.white,
      child: Row(
        children: [
          // Home (back) tab
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                color: AppColors.lightGreen,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.backBtn, width: 18, height: 18,
                        color: AppColors.primary),
                    const SizedBox(height: 2),
                    const Text(
                      'Home',
                      textAlign: TextAlign.center,
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

          // Store tab
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => setState(() => _currentIndex = 0),
              child: Container(
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? AppColors.lightGreen : AppColors.white,
                  border: const Border(top: BorderSide(color: AppColors.greyBorder, width: 0.5)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.icCart, width: 22, height: 22,
                        color: _currentIndex == 0 ? AppColors.primary : AppColors.gray),
                    const SizedBox(height: 2),
                    Text(
                      'Store',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _currentIndex == 0 ? AppColors.primary : AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Orders tab
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => setState(() => _currentIndex = 1),
              child: Container(
                decoration: BoxDecoration(
                  color: _currentIndex == 1 ? AppColors.lightGreen : AppColors.white,
                  border: const Border(top: BorderSide(color: AppColors.greyBorder, width: 0.5)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.activity, width: 22, height: 22,
                        color: _currentIndex == 1 ? AppColors.primary : AppColors.gray),
                    const SizedBox(height: 2),
                    Text(
                      'Activity',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _currentIndex == 1 ? AppColors.primary : AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
