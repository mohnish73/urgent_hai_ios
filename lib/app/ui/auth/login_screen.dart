import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../utils/custom_app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showSnack('Mobile number is required');
      return;
    }
    if (phone.length != 10) {
      _showSnack('Enter valid mobile number');
      return;
    }
    final provider = context.read<AuthProvider>();
    final success = await provider.generateOtp(phone);
    if (!mounted) return;
    if (success && provider.otpData != null) {
      context.push(AppRoutes.otp, extra: {
        'phone': phone,
        'id': provider.otpData!.id,
      });
    } else {
      _showSnack(provider.errorMessage);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Urbanist')),
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back button ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Image.asset(AppImages.back, width: 32, height: 32),
              ),
            ),

            // ── Logo (centered) ──────────────────────────
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ClipOval(
                  child: Image.asset(AppImages.logo, width: 120, height: 120, fit: BoxFit.cover),
                ),
              ),
            ),

            // ── Title ────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Text(
                'Welcome back! Glad\n to see you, Again!',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),

            // ── Phone field ──────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.gray, width: 0.3),
                ),
                child: Row(
                  children: [
                    Image.asset(AppImages.flag, width: 32),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter your Mobile No.',
                          hintStyle: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Continue button ──────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Consumer<AuthProvider>(
                builder: (_, auth, __) => CustomAppButton(
                  title: 'Continue',
                  borderRadius: 50,
                  isLoading: auth.isLoading,
                  onPressed: auth.isLoading ? null : _onContinue,
                ),
              ),
            ),

            // ── Register link ────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.signup),
                    child: const Text(
                      ' Register Now',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
