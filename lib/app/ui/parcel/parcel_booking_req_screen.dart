import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/storage/hive_service.dart';
import '../../model/parcel/parcel_model.dart';
import '../../routes/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_strings.dart';
import '../../utils/custom_app_button.dart';
import '../../utils/widgets/app_toggle.dart';
import '../../utils/widgets/custom_text_field.dart';

class ParcelBookingReqScreen extends StatefulWidget {
  final String pickup;
  final String drop;
  final double pickupLat;
  final double pickupLng;
  final double dropLat;
  final double dropLng;

  const ParcelBookingReqScreen({
    super.key,
    required this.pickup,
    required this.drop,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
  });

  @override
  State<ParcelBookingReqScreen> createState() => _ParcelBookingReqScreenState();
}

class _ParcelBookingReqScreenState extends State<ParcelBookingReqScreen> {
  final _heightCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  final _senderNameCtrl = TextEditingController();
  final _senderMobileCtrl = TextEditingController();
  bool _isSender = false;

  final _receiverNameCtrl = TextEditingController();
  final _receiverMobileCtrl = TextEditingController();
  bool _isReceiver = false;

  bool _acceptTerms = false;

  @override
  void dispose() {
    _heightCtrl.dispose();
    _widthCtrl.dispose();
    _weightCtrl.dispose();
    _senderNameCtrl.dispose();
    _senderMobileCtrl.dispose();
    _receiverNameCtrl.dispose();
    _receiverMobileCtrl.dispose();
    super.dispose();
  }

  void _onSenderToggle(bool v) {
    setState(() {
      _isSender = v;
      if (v) {
        _isReceiver = false;
        _senderNameCtrl.text = HiveService.getFullName();
        _senderMobileCtrl.text = HiveService.getMobileNo() ?? '';
      } else {
        _senderNameCtrl.clear();
        _senderMobileCtrl.clear();
      }
    });
  }

  void _onReceiverToggle(bool v) {
    setState(() {
      _isReceiver = v;
      if (v) {
        _isSender = false;
        _receiverNameCtrl.text = HiveService.getFullName();
        _receiverMobileCtrl.text = HiveService.getMobileNo() ?? '';
      } else {
        _receiverNameCtrl.clear();
        _receiverMobileCtrl.clear();
      }
    });
  }

  bool _isValidPhone(String phone) => phone.length == 10;

  void _onConfirm() {
    final height = _heightCtrl.text.trim();
    final width = _widthCtrl.text.trim();
    final weight = _weightCtrl.text.trim();
    final senderName = _senderNameCtrl.text.trim();
    final senderMobile = _senderMobileCtrl.text.trim();
    final receiverName = _receiverNameCtrl.text.trim();
    final receiverMobile = _receiverMobileCtrl.text.trim();

    String? error;
    if (height.isEmpty) {
      error = AppStrings.parcelErrorHeight;
    } else if (width.isEmpty) {
      error = AppStrings.parcelErrorWidth;
    } else if (weight.isEmpty) {
      error = AppStrings.parcelErrorWeight;
    } else if (senderName.isEmpty) {
      error = AppStrings.parcelErrorSenderName;
    } else if (senderMobile.isEmpty) {
      error = AppStrings.parcelErrorSenderMobile;
    } else if (!_isValidPhone(senderMobile)) {
      error = AppStrings.parcelErrorSenderMobileInvalid;
    } else if (receiverName.isEmpty) {
      error = AppStrings.parcelErrorReceiverName;
    } else if (receiverMobile.isEmpty) {
      error = AppStrings.parcelErrorReceiverMobile;
    } else if (!_isValidPhone(receiverMobile)) {
      error = AppStrings.parcelErrorReceiverMobileInvalid;
    } else if (!_acceptTerms) {
      error = AppStrings.parcelErrorTerms;
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error, style: const TextStyle(fontFamily: 'Urbanist'))),
      );
      return;
    }

    final userId = HiveService.getUserId() ?? '';
    final mobile = HiveService.getMobileNo() ?? '';

    final parcelRequest = ParcelRequestModel(
      userId: int.tryParse(userId) ?? 0,
      userMobileNumber: mobile,
      sender: ParcelSenderModel(
        name: senderName,
        mobileNumber: senderMobile,
        isSending: _isSender,
      ),
      receiver: ParcelReceiverModel(
        name: receiverName,
        mobileNumber: receiverMobile,
        isReceiving: _isReceiver,
      ),
      parcelInfo: ParcelInfoModel(
        height: int.tryParse(height) ?? 0,
        width: int.tryParse(width) ?? 0,
        weightKg: double.tryParse(weight) ?? 0.0,
      ),
    );

    context.push(AppRoutes.bookParcel, extra: {
      'pickup': widget.pickup,
      'drop': widget.drop,
      'pickupLat': widget.pickupLat,
      'pickupLng': widget.pickupLng,
      'dropLat': widget.dropLat,
      'dropLng': widget.dropLng,
      'parcelRequest': parcelRequest,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Image.asset(
                      'assets/images/back.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    AppStrings.parcelScreenTitle,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Parcel Dimensions ──────────────────────
                    const Text(
                      AppStrings.parcelSectionDetails,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _heightCtrl,
                      hintText: AppStrings.parcelHintHeight,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _widthCtrl,
                      hintText: AppStrings.parcelHintWidth,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _weightCtrl,
                      hintText: AppStrings.parcelHintWeight,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      maxLength: 10,
                    ),

                    const SizedBox(height: 20),

                    // ── Sender Details ─────────────────────────
                    const Text(
                      AppStrings.parcelSectionSender,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        AppToggle(
                          value: _isSender,
                          onChanged: _onSenderToggle,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          AppStrings.parcelYouAreSender,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: _senderNameCtrl,
                      hintText: AppStrings.parcelHintSenderName,
                      maxLength: 50,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _senderMobileCtrl,
                      hintText: AppStrings.parcelHintSenderMobile,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),

                    const SizedBox(height: 20),

                    // ── Receiver Details ───────────────────────
                    const Text(
                      AppStrings.parcelSectionReceiver,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        AppToggle(
                          value: _isReceiver,
                          onChanged: _onReceiverToggle,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          AppStrings.parcelYouAreReceiver,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: _receiverNameCtrl,
                      hintText: AppStrings.parcelHintReceiverName,
                      maxLength: 50,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _receiverMobileCtrl,
                      hintText: AppStrings.parcelHintReceiverMobile,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),

                    const SizedBox(height: 15),

                    // ── Terms & Conditions ─────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          activeColor: AppColors.primary,
                          onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: AppStrings.parcelAcceptTerms,
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: AppStrings.parcelTermsLink,
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1976D2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    CustomAppButton(
                      title: AppStrings.parcelConfirmBooking,
                      onPressed: _onConfirm,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
