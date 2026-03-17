import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';
import '../../utils/custom_app_button.dart';

class OnBoard1Screen extends StatelessWidget {
  const OnBoard1Screen({super.key});

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
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(AppImages.ob1, fit: BoxFit.fitHeight),
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
                    AppStrings.ob1Title,
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
                      AppStrings.ob1Desc,
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

                  // Progress dots (page 1 active)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.greenRectangle, width: AppConstants.dotActiveWidth),
                        const SizedBox(width: 10),
                        Image.asset(AppImages.greenLightRectangle, width: AppConstants.dotInactiveWidth),
                        const SizedBox(width: 10),
                        Image.asset(AppImages.greenLightRectangle, width: AppConstants.dotInactiveWidth),
                      ],
                    ),
                  ),

                  // Skip | Continue buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomAppButton(
                          title: AppStrings.btnSkip,
                          color: AppColors.lightGreen,
                          textColor: AppColors.primary,
                          borderRadius: AppConstants.radiusPill,
                          buttonHeight: AppConstants.buttonHeight,
                          onPressed: () => context.go(AppRoutes.login),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomAppButton(
                          title: AppStrings.btnContinue,
                          borderRadius: AppConstants.radiusPill,
                          buttonHeight: AppConstants.buttonHeight,
                          onPressed: () => context.go(AppRoutes.onboard2),
                        ),
                      ),
                    ],
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
