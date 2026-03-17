import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(title: const Text('Categories')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2,
        ),
        // TODO: Load categories from API
        itemCount: 6,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => context.push(AppRoutes.products),
          child: Container(
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
            child: const Center(
              child: Text('Category', style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}
