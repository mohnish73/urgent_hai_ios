import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';
import '../../utils/custom_app_button.dart';

class SignupSuccessScreen extends StatefulWidget {
  final int userId;
  final String phone;

  const SignupSuccessScreen({
    super.key,
    required this.userId,
    required this.phone,
  });

  @override
  State<SignupSuccessScreen> createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final provider = context.read<AuthProvider>();
    final success = await provider.getProfile(
      userId: widget.userId,
      phone: widget.phone,
    );
    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back button ──────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Image.asset(AppImages.back,
                        width: AppConstants.backBtnSizeLg,
                        height: AppConstants.backBtnSizeLg),
                  ),
                ),

                // ── "All Done" title ─────────────────────
                const Padding(
                  padding: EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: Text(
                    AppStrings.signupSuccessTitle,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),

                // ── Description + verified icon ──────────
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            AppStrings.signupSuccessDesc,
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                      Image.asset(AppImages.verified,
                          width: AppConstants.verifiedIconSize,
                          height: AppConstants.verifiedIconSize),
                    ],
                  ),
                ),

                // ── Successful purchase image ────────────
                Padding(
                  padding: const EdgeInsets.only(top: 80, right: 120),
                  child: Image.asset(
                    AppImages.successfulPurchase,
                    width: double.infinity,
                    height: AppConstants.successImageHeight,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),

            // ── "Let's Go" button at bottom ──────────────
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Consumer<AuthProvider>(
                builder: (_, auth, __) => CustomAppButton(
                  title: AppStrings.signupSuccessBtn,
                  borderRadius: AppConstants.radiusPill,
                  isLoading: auth.isLoading,
                  onPressed: auth.isLoading
                      ? null
                      : () => context.go(AppRoutes.dashboard),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
