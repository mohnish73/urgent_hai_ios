import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';

class AddressTab extends StatelessWidget {
  const AddressTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('My Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.addAddress),
          ),
        ],
      ),
      body: const Center(
        // TODO: Load and list saved addresses from API
        child: Text('No addresses saved yet.', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
      ),
    );
  }
}
