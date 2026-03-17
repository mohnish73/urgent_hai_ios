import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'tabs/ride_book_tab.dart';
import 'tabs/ride_activity_tab.dart';

class RideDashboardScreen extends StatefulWidget {
  const RideDashboardScreen({super.key});

  @override
  State<RideDashboardScreen> createState() => _RideDashboardScreenState();
}

class _RideDashboardScreenState extends State<RideDashboardScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Ride'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.gray,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Book Ride'), Tab(text: 'Activity')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [RideBookTab(), RideActivityTab()],
      ),
    );
  }
}
