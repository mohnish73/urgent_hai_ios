import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/storage/hive_service.dart';
import '../../../provider/auth_provider.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isDeleting = false;

  Future<void> _confirmDeleteAccount() async {
    final provider = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Delete Account',
          style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(fontFamily: 'Urbanist'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                  fontFamily: 'Urbanist',
                  color: AppColors.red,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);
    final success = await provider.deleteAccount();

    if (!mounted) return;
    setState(() => _isDeleting = false);

    if (success) {
      router.go(AppRoutes.login);
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(provider.errorMessage)),
      );
    }
  }

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

            // ── Name + Mobile ──────────────────────────────────
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    HiveService.getFullName().isEmpty
                        ? 'User'
                        : HiveService.getFullName(),
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

                  // ── Delete Account ─────────────────────────
                  _ProfileMenuItem(
                    icon: AppImages.signout,
                    label: _isDeleting ? 'Deleting...' : 'Delete Account',
                    labelColor: AppColors.red,
                    showArrow: false,
                    onTap: _isDeleting ? () {} : _confirmDeleteAccount,
                  ),

                  // ── Sign Out ───────────────────────────────
                  _ProfileMenuItem(
                    icon: AppImages.signout,
                    label: 'Sign Out',
                    showArrow: false,
                    onTap: () async {
                      await HiveService.clearAll();
                      if (context.mounted) context.go(AppRoutes.login);
                    },
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
  final Color labelColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showArrow = true,
    this.labelColor = const Color(0xFF3F3F3F),
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
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
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
