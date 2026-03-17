import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'tabs/parcel_book_tab.dart';
import 'tabs/parcel_activity_tab.dart';

class ParcelDashboardScreen extends StatefulWidget {
  const ParcelDashboardScreen({super.key});

  @override
  State<ParcelDashboardScreen> createState() => _ParcelDashboardScreenState();
}

class _ParcelDashboardScreenState extends State<ParcelDashboardScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Parcel'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.gray,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Send Parcel'), Tab(text: 'Activity')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ParcelBookTab(), ParcelActivityTab()],
      ),
    );
  }
}
