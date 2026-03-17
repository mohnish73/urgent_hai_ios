import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../model/auth/signup_model.dart';
import '../../provider/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';
import '../../utils/custom_app_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final fname = _firstNameController.text.trim();
    final lname = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (fname.isEmpty) { _showSnack(AppStrings.errorFirstNameRequired); return; }
    if (lname.isEmpty) { _showSnack(AppStrings.errorLastNameRequired); return; }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) { _showSnack(AppStrings.errorEmailRequired); return; }
    if (phone.isEmpty) { _showSnack(AppStrings.errorMobileRequired); return; }
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) { _showSnack(AppStrings.errorMobileInvalid); return; }

    final request = SignUpRequestModel(
      firstName: fname,
      lastName: lname,
      mobileNo: phone,
      email: email,
      dateOfBirth: AppConstants.defaultDateOfBirth,
      gender: AppConstants.defaultGender,
    );

    final provider = context.read<AuthProvider>();
    final userId = await provider.signUp(request);
    if (!mounted) return;

    if (userId != null) {
      context.go(AppRoutes.signupSuccess, extra: {'userId': userId, 'phone': phone});
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

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLength = 200,
    List<TextInputFormatter>? formatters,
  }) {
    return Container(
      height: AppConstants.fieldHeight,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppConstants.radiusField),
        border: Border.all(color: AppColors.gray, width: 0.3),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: formatters,
        style: const TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: 'Urbanist', color: AppColors.gray),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back button ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingScreen,
                    vertical: AppConstants.paddingScreen),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Image.asset(AppImages.back,
                      width: AppConstants.backBtnSizeLg,
                      height: AppConstants.backBtnSizeLg),
                ),
              ),

              // ── Title ──────────────────────────────────────
              const Padding(
                padding: EdgeInsets.only(
                    top: 15,
                    left: AppConstants.paddingScreen,
                    right: AppConstants.paddingScreen),
                child: Text(
                  AppStrings.signupTitle,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),

              // ── Form fields ────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(
                    top: 30,
                    left: AppConstants.paddingButton,
                    right: AppConstants.paddingButton),
                child: Column(
                  children: [
                    _buildField(
                        controller: _firstNameController,
                        hint: AppStrings.signupFirstNameHint,
                        maxLength: AppConstants.nameMaxLength),
                    _buildField(
                        controller: _lastNameController,
                        hint: AppStrings.signupLastNameHint,
                        maxLength: AppConstants.nameMaxLength),
                    _buildField(
                        controller: _emailController,
                        hint: AppStrings.signupEmailHint,
                        keyboardType: TextInputType.emailAddress),
                    _buildField(
                      controller: _phoneController,
                      hint: AppStrings.signupPhoneHint,
                      keyboardType: TextInputType.phone,
                      maxLength: AppConstants.phoneLengthMax,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),

              // ── Continue button ────────────────────────────
              Padding(
                padding: const EdgeInsets.only(
                    top: 30,
                    left: AppConstants.paddingButton,
                    right: AppConstants.paddingButton),
                child: Consumer<AuthProvider>(
                  builder: (_, auth, __) => CustomAppButton(
                    title: AppStrings.signupContinue,
                    borderRadius: AppConstants.radiusPill,
                    isLoading: auth.isLoading,
                    onPressed: auth.isLoading ? null : _onContinue,
                  ),
                ),
              ),

              // ── Login link ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.signupHaveAccount,
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Text(
                        AppStrings.signupLoginNow,
                        style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
