import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../utils/custom_app_button.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final String id;

  const OtpScreen({super.key, required this.phone, required this.id});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  late String _currentId;
  int _resendSeconds = 60;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentId = widget.id;
    _startTimer();
  }

  void _startTimer() {
    _resendSeconds = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      _showSnack('Enter valid otp');
      return;
    }
    final provider = context.read<AuthProvider>();
    final success = await provider.verifyOtp(
      id: _currentId,
      otp: otp,
      phone: widget.phone,
    );
    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.dashboard);
    } else {
      _showSnack(provider.errorMessage);
    }
  }

  Future<void> _onResend() async {
    _otpController.clear();
    final provider = context.read<AuthProvider>();
    final success = await provider.resendOtp(widget.phone);
    if (!mounted) return;
    if (success && provider.otpData != null) {
      _currentId = provider.otpData!.id;
      _startTimer();
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
    final pinTheme = PinTheme(
      width: 40,
      height: 40,
      textStyle: const TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.gray, width: 0.3),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back button ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Image.asset(AppImages.back, width: 32, height: 32),
              ),
            ),

            // ── Logo (centered) ────────────────────────────
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ClipOval(
                  child: Image.asset(AppImages.logo, width: 80, height: 80, fit: BoxFit.cover),
                ),
              ),
            ),

            // ── Title ──────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Text(
                'OTP',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),

            // ── Pinput ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Center(
                child: Pinput(
                  controller: _otpController,
                  length: 6,
                  defaultPinTheme: pinTheme,
                  focusedPinTheme: pinTheme.copyWith(
                    decoration: pinTheme.decoration!.copyWith(
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  obscureText: true,
                  autofocus: true,
                  onCompleted: (_) => _onLogin(),
                ),
              ),
            ),

            // ── Login button ───────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Consumer<AuthProvider>(
                builder: (_, auth, __) => CustomAppButton(
                  title: 'Login',
                  borderRadius: 50,
                  isLoading: auth.isLoading,
                  onPressed: auth.isLoading ? null : _onLogin,
                ),
              ),
            ),

            // ── Resend timer ───────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _canResend
                        ? 'You can resend the code'
                        : 'You can resend the code in  ${_resendSeconds}s',
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            // ── Resend Code ────────────────────────────────
            if (_canResend)
              Consumer<AuthProvider>(
                builder: (_, auth, __) => Padding(
                  padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
                  child: CustomAppButton(
                    title: 'Resend Code',
                    borderRadius: 50,
                    color: AppColors.lightGreen,
                    textColor: AppColors.primary,
                    isLoading: auth.isLoading,
                    onPressed: auth.isLoading ? null : _onResend,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
