import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/ride/book_ride_model.dart';
import '../../provider/ride_provider.dart';
import '../../services/network/response/api_response.dart';
import '../../services/network/response/global_error_handle.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';

class RideDetailsScreen extends StatefulWidget {
  final BookRideData booking;

  const RideDetailsScreen({super.key, required this.booking});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  bool _cancelling = false;

  Future<void> _onCancel() async {
    setState(() => _cancelling = true);
    final ok = await context.read<RideProvider>().cancelRide(widget.booking.riderBook);
    if (!mounted) return;
    setState(() => _cancelling = false);
    if (ok) {
      context.pop();
    } else {
      GlobalErrorHandler.handle(
        context,
        ApiResponse.error('Failed to cancel ride. Please try again.'),
        onRetry: _onCancel,
      );
    }
  }

  Future<void> _callDriver(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header: back + "Trip Details" ────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Image.asset(AppImages.back, width: 32, height: 32),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Trip Details',
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
              child: Column(
                children: [
                  // ── Route CardView (elevation 4, radius 8) ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            // Start row: green_dot + EditText (readonly)
                            Row(
                              children: [
                                Image.asset(AppImages.greenDot,
                                    width: 12, height: 12),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: b.pickupAddress),
                                      style: const TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter start destination',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Urbanist',
                                          color: AppColors.gray,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Divider (grey, margin left 28dp)
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 28, right: 10, top: 5, bottom: 5),
                              height: 1,
                              color: AppColors.grey,
                            ),

                            // End row: red_dot + EditText
                            Row(
                              children: [
                                Image.asset(AppImages.redDot,
                                    width: 12, height: 12),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: b.dropAddress),
                                      style: const TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter end destination',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Urbanist',
                                          color: AppColors.gray,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── "Recommended options" section (light_green bg) ──
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: double.infinity,
                    color: AppColors.lightGreen,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: const Text(
                      'Recommended options',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                    ),
                  ),

                  // ── Separator ────────────────────────────────
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 1,
                    color: AppColors.grey,
                  ),

                  // ── OTP row: "Start your ride with your PIN" (left) + OTP box (right) ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        // Left: label
                        const Expanded(
                          child: Text(
                            'Start your ride with your PIN',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              color: AppColors.black,
                            ),
                          ),
                        ),

                        // Right: OTP in rounded grey box
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.greyBorder, width: 0.5),
                          ),
                          child: Text(
                            b.otp.isNotEmpty ? b.otp : '----',
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Driver CardView ───────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            // Auto icon 40dp
                            Image.asset(AppImages.auto,
                                width: 40, height: 40, fit: BoxFit.contain),
                            const SizedBox(width: 10),

                            // Vehicle no + name + rating
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Vehicle no: rectangle_lightyellow_black_border
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightyellow,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: AppColors.black, width: 0.5),
                                    ),
                                    child: Text(
                                      b.vehicleNo.isNotEmpty
                                          ? b.vehicleNo
                                          : 'N/A',
                                      style: const TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),

                                  // Name + rating (rounded_lightgreen)
                                  Row(
                                    children: [
                                      Text(
                                        b.driverName.isNotEmpty
                                            ? b.driverName
                                            : 'Searching...',
                                        style: const TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      if (b.driverRating.isNotEmpty) ...[
                                        const SizedBox(width: 15),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGreen,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                b.driverRating,
                                                style: const TextStyle(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              Image.asset(
                                                AppImages.pinYellow,
                                                width: 14,
                                                height: 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Call button: green_circle, 32dp, margin right 10dp
                            GestureDetector(
                              onTap: () => _callDriver(b.driverNo),
                              child: Container(
                                width: 32,
                                height: 32,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.call,
                                    color: AppColors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ── Bottom row: warning text (weight 2) + cancel btn (weight 1) ──
                  // Matches paymentLayout in activity_get_ride_dashbaord_details.xml
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        // Warning text
                        const Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              '❗ Once booked, cancellation charges may apply.',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 10,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),

                        // Cancel button (red bg, pill shape, weight 1)
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: _cancelling ? null : _onCancel,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.center,
                              child: _cancelling
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          color: AppColors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'Cancel Ride',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
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
