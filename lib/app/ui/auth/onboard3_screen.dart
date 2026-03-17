import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/storage/hive_service.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';
import '../../utils/custom_app_button.dart';

class OnBoard3Screen extends StatelessWidget {
  const OnBoard3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // ── Top half: green bg + image ─────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppConstants.radiusOnboardTop),
                  bottomRight: Radius.circular(AppConstants.radiusOnboardTop),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(AppImages.ob3, fit: BoxFit.fitHeight),
              ),
            ),
          ),

          // ── Bottom half: white content ─────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  const Text(
                    AppStrings.ob3Title,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      AppStrings.ob3Desc,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),

                  // Progress dots (page 3 active)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.greenLightRectangle, width: AppConstants.dotInactiveWidth),
                        const SizedBox(width: 10),
                        Image.asset(AppImages.greenLightRectangle, width: AppConstants.dotInactiveWidth),
                        const SizedBox(width: 10),
                        Image.asset(AppImages.greenRectangle, width: AppConstants.dotActiveWidth),
                      ],
                    ),
                  ),

                  // Only Continue (no skip on last screen)
                  CustomAppButton(
                    title: AppStrings.btnContinue,
                    borderRadius: AppConstants.radiusPill,
                    buttonHeight: AppConstants.buttonHeight,
                    onPressed: () async {
                      await HiveService.setOnboardingDone();
                      if (context.mounted) context.go(AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
