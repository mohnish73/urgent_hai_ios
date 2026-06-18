import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';

class CustomOrderScreen extends StatefulWidget {
  const CustomOrderScreen({super.key});

  @override
  State<CustomOrderScreen> createState() => _CustomOrderScreenState();
}

class _CustomOrderScreenState extends State<CustomOrderScreen> {
  File? _photo;
  final _descCtrl = TextEditingController();
  bool _showSheet = false;
  bool _orderDone = false;
  Timer? _timer;

  @override
  void dispose() {
    _descCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _photo = File(picked.path));
    }
  }

  bool get _canOrder =>
      _photo != null || _descCtrl.text.trim().isNotEmpty;

  Future<void> _placeOrder() async {
    if (!_canOrder) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please upload a photo or enter a description.',
              style: TextStyle(fontFamily: 'Urbanist')),
        ),
      );
      return;
    }

    setState(() {
      _showSheet = true;
      _orderDone = false;
    });

    _timer = Timer(const Duration(milliseconds: 5500), () {
      if (!mounted) return;
      setState(() => _orderDone = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.storeOrderSuccess,
              style: TextStyle(fontFamily: 'Urbanist')),
        ),
      );

      _timer = Timer(const Duration(milliseconds: 2000), () {
        if (!mounted) return;
        context.pushReplacement(AppRoutes.order);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Stack(
        children: [
          // ── Main screen ─────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  color: AppColors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Image.asset(AppImages.backBtn,
                            width: 30, height: 30, color: AppColors.black),
                      ),
                      const Expanded(
                        child: Text(
                          AppStrings.storeCustomOrder,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ── Upload picture section ─────
                        const Text(
                          AppStrings.storeUploadPicture,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),

                        const SizedBox(height: 10),

                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.primary, width: 1.5),
                            ),
                            child: _photo != null
                                ? ClipOval(
                                    child: Image.file(_photo!,
                                        fit: BoxFit.cover),
                                  )
                                : const Icon(Icons.camera_alt,
                                    size: 32, color: AppColors.primary),
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          AppStrings.storeUploadPhotoHint,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 11,
                            color: AppColors.gray,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // ── OR divider ─────────────────
                        Row(
                          children: [
                            const Expanded(
                                child: Divider(color: AppColors.grey)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                AppStrings.storeOr,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.gray,
                                ),
                              ),
                            ),
                            const Expanded(
                                child: Divider(color: AppColors.grey)),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // ── Description input ──────────
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.greyBorder, width: 0.5),
                          ),
                          child: TextField(
                            controller: _descCtrl,
                            maxLines: 3,
                            maxLength: 50,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              hintText: AppStrings.storeEnterDesc,
                              hintStyle: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13,
                                color: AppColors.gray,
                              ),
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13,
                              color: AppColors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Order button ───────────────
                        GestureDetector(
                          onTap: _placeOrder,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              AppStrings.storeOrder,
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom sheet overlay ────────────────
          if (_showSheet)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 280,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.greyBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset(
                            _orderDone
                                ? AppImages.gifGreenTick
                                : AppImages.gifFood,
                            key: ValueKey(_orderDone),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
