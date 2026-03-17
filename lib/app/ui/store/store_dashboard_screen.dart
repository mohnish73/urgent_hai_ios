import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'tabs/store_home_tab.dart';
import 'tabs/orders_tab.dart';

class StoreDashboardScreen extends StatefulWidget {
  const StoreDashboardScreen({super.key});

  @override
  State<StoreDashboardScreen> createState() => _StoreDashboardScreenState();
}

class _StoreDashboardScreenState extends State<StoreDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Store'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.gray,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Shop'), Tab(text: 'My Orders')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [StoreHomeTab(), OrdersTab()],
      ),
    );
  }
}
