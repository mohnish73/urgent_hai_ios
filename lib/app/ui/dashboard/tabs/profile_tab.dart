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
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Profile Picture ────────────────────────────────
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 40,
              backgroundImage: const AssetImage(AppImages.samplePic),
              backgroundColor: Colors.transparent,
            ),

            // ── Name + Email ───────────────────────────────────
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    HiveService.getFullName().isEmpty ? 'User' : HiveService.getFullName(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F3F3F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    HiveService.getMobileNo() ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),

            // ── Menu Items ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: AppImages.profileOutline,
                    label: 'About Me',
                    onTap: () => context.push(AppRoutes.aboutMe),
                  ),
                  _ProfileMenuItem(
                    icon: AppImages.parcel,
                    label: 'Ticket',
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: AppImages.notification,
                    label: 'Notifications',
                    onTap: () => context.push(AppRoutes.notifications),
                  ),
                  _ProfileMenuItem(
                    icon: AppImages.signout,
                    label: 'Sign Out',
                    showArrow: false,
                    onTap: () async {
                      await HiveService.clearAll();
                      if (context.mounted) context.go(AppRoutes.login);},
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Version ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'v1.4',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3F3F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool showArrow;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(icon, width: 16, height: 16),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3F3F),
                ),
              ),
            ),
            if (showArrow)
              Image.asset(AppImages.rightArrow, width: 16, height: 16),
          ],
        ),
      ),
    );
  }
}
