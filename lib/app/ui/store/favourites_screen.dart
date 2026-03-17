import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(title: const Text('Favourites')),
      body: Center(
        // TODO: Load wishlist from SharedPreferences
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppImages.gifNoDataFound, width: 180, height: 180),
            const SizedBox(height: 12),
            const Text('No favourites yet.', style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
