import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/storage/hive_service.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(title: const Text('Profile'), backgroundColor: AppColors.white),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Avatar + Name ─────────────────────────────────
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.lightGreen,
                  backgroundImage: AssetImage(AppImages.profilePicOutline),
                ),
                const SizedBox(height: 12),
                // Text(
                //   HiveService.getName() ?? 'User',
                //   style: const TextStyle(fontFamily: 'Urbanist', fontSize: 20, fontWeight: FontWeight.w700),
                // ),
                Text(
                  HiveService.getMobileNo() ?? '',
                  style: const TextStyle(fontFamily: 'Urbanist', color: AppColors.gray),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Menu Items ─────────────────────────────────────
          _ProfileMenuItem(icon: AppImages.profile, label: 'About Me', onTap: () => context.push(AppRoutes.aboutMe)),
          _ProfileMenuItem(icon: AppImages.address, label: 'My Addresses', onTap: () => context.push(AppRoutes.addAddress)),
          _ProfileMenuItem(icon: AppImages.notification, label: 'Notifications', onTap: () => context.push(AppRoutes.notifications)),
          const Divider(height: 32),
          _ProfileMenuItem(
            icon: AppImages.signout,
            label: 'Sign Out',
            labelColor: AppColors.red,
            onTap: () async {
              await HiveService.clearAll();
              if (context.mounted) context.go(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color labelColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(icon, width: 24, height: 24),
      title: Text(label, style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w500, color: labelColor)),
      trailing: Image.asset(AppImages.rightArrow, width: 18, height: 18),
      onTap: onTap,
    );
  }
}
