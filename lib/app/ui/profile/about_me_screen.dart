import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/storage/hive_service.dart';
import '../../model/auth/signup_model.dart';
import '../../provider/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../utils/custom_app_button.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  String _mobile = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = HiveService.getFirstName() ?? '';
    _lastNameController.text = HiveService.getLastName() ?? '';
    _emailController.text = HiveService.getEmail() ?? '';
    _mobile = HiveService.getMobileNo() ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email);

  Future<void> _save() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    if (firstName.isEmpty) {
      _showSnack('Please enter your first name');
      return;
    }
    if (lastName.isEmpty) {
      _showSnack('Please enter your last name');
      return;
    }
    if (email.isNotEmpty && !_isValidEmail(email)) {
      _showSnack('Please enter a valid email');
      return;
    }

    setState(() => _isLoading = true);

    final request = SignUpRequestModel(
      pkUserId: int.tryParse(HiveService.getUserId() ?? '0') ?? 0,
      firstName: firstName,
      lastName: lastName,
      mobileNo: _mobile,
      dateOfBirth: HiveService.getDateOfBirth() ?? '2025-01-01',
      gender: HiveService.getGender() ?? 'Male',
      email: email,
      generalNotification: HiveService.getGeneralNotification(),
      orderNotification: HiveService.getOrderNotification(),
      emailNotification: HiveService.getEmailNotification(),
    );

    final provider = context.read<AuthProvider>();
    final success = await provider.updateProfile(request);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      _showSnack('Profile updated successfully');
      Navigator.pop(context);
    } else {
      _showSnack(provider.errorMessage);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 60,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(AppImages.backBtn),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'About Me',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Form Content ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ── Section Label ──────────────────────────
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Personal Details',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // ── First Name ─────────────────────────────
                  _InputRow(
                    icon: AppImages.profilePicOutline,
                    child: TextField(
                      controller: _firstNameController,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 50,
                      style: _fieldStyle,
                      decoration: _fieldDecoration('Enter your first name'),
                    ),
                  ),

                  // ── Last Name ──────────────────────────────
                  _InputRow(
                    marginTop: 5,
                    icon: AppImages.profilePicOutline,
                    child: TextField(
                      controller: _lastNameController,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 50,
                      style: _fieldStyle,
                      decoration: _fieldDecoration('Enter your last name'),
                    ),
                  ),

                  // ── Mobile (read-only) ─────────────────────
                  _InputRow(
                    marginTop: 5,
                    marginBottom: 5,
                    icon: AppImages.telephone,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _mobile.isNotEmpty ? _mobile : 'Enter your Mobile No.',
                          style: _mobile.isNotEmpty
                              ? _fieldStyle
                              : _fieldStyle.copyWith(
                                  color: AppColors.gray,
                                  fontWeight: FontWeight.normal,
                                ),
                        ),
                      ),
                    ),
                  ),

                  // ── Email ──────────────────────────────────
                  _InputRow(
                    icon: AppImages.email,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      style: _fieldStyle,
                      decoration: _fieldDecoration('Enter your email'),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Save Button ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: CustomAppButton(
              title: 'Save Settings',
              isLoading: _isLoading,
              onPressed: _save,
              buttonHeight: 50,
            ),
          ),
        ],
      ),
    );
  }

  static const TextStyle _fieldStyle = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static InputDecoration _fieldDecoration(String hint) => InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.gray,
        ),
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      );
}

class _InputRow extends StatelessWidget {
  final String icon;
  final Widget child;
  final double marginTop;
  final double marginBottom;

  const _InputRow({
    required this.icon,
    required this.child,
    this.marginTop = 0,
    this.marginBottom = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: AppColors.white,
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Image.asset(icon, height: 22, fit: BoxFit.contain),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
