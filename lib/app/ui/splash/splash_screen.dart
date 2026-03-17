import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../../core/storage/hive_service.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2000)),
      _requestLocationPermission(),
    ]);
    if (!mounted) return;

    final onboardingDone = HiveService.getOnboardingDone();
    final isLoggedIn = HiveService.isLoggedIn();

    if (!onboardingDone) {
      context.go(AppRoutes.onboard1);
    } else if (!isLoggedIn) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.dashboard);
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Doodle tiled background (full screen)
          Positioned.fill(
            child: Image.asset(
              AppImages.doodleBg,
              repeat: ImageRepeat.repeat,
              fit: BoxFit.none,
              alignment: Alignment.topLeft,
            ),
          ),

          // Circle logo centered
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  AppImages.logo,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
