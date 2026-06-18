import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/ride/ride_history_model.dart';
import '../../provider/ride_provider.dart';
import '../../services/network/response/api_response.dart';
import '../../services/network/response/global_error_handle.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/app_strings.dart';

class ParcelDetailsScreen extends StatefulWidget {
  final int bookingId;

  const ParcelDetailsScreen({super.key, required this.bookingId});

  @override
  State<ParcelDetailsScreen> createState() => _ParcelDetailsScreenState();
}

class _ParcelDetailsScreenState extends State<ParcelDetailsScreen> {
  RideHistoryData? _booking;
  bool _cancelling = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RideProvider>().fetchParcelHistory();
    });
  }

  Future<void> _onCancel() async {
    if (_booking == null) return;
    setState(() => _cancelling = true);
    final ok = await context.read<RideProvider>().cancelParcel(_booking!.riderBook);
    if (!mounted) return;
    setState(() => _cancelling = false);
    if (ok) {
      context.pop();
    } else {
      GlobalErrorHandler.handle(
        context,
        ApiResponse.error('Failed to cancel parcel. Please try again.'),
        onRetry: _onCancel,
      );
    }
  }

  Future<void> _callDriver(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  String _formatVehicleNo(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i > 0 && i % 2 == 0) buffer.write(' ');
      buffer.write(input[i]);
    }
    return buffer.toString();
  }

  Color _statusColor(String status) {
    if (status.toLowerCase().contains('upcoming')) return AppColors.lightyellow;
    if (status.toLowerCase().contains('cancel')) return AppColors.lightRed;
    if (status.toLowerCase().contains('complete')) return AppColors.primary;
    return AppColors.lightGreen;
  }

  String _statusLabel(String status) {
    if (status.toLowerCase().contains('upcoming')) return 'Your parcel has been confirmed!';
    if (status.toLowerCase().contains('cancel')) return 'Your parcel has been cancelled.';
    if (status.toLowerCase().contains('complete')) return 'Your parcel has been delivered!';
    return 'Your parcel is on the way.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Consumer<RideProvider>(
        builder: (_, provider, __) {
          // Filter parcel history by bookingId
          if (provider.parcelHistory.isSuccess && provider.parcelHistory.data != null) {
            final found = provider.parcelHistory.data!
                .where((h) => h.riderBook == widget.bookingId)
                .toList();
            if (found.isNotEmpty) _booking = found.first;
          }

          final b = _booking;

          return SafeArea(
            child: Column(
              children: [
                // ── Header ────────────────────────────────────
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
                        AppStrings.parcelDetailsTitle,
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

                if (provider.parcelHistory.isLoading)
                  const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary)),
                  )
                else if (b == null)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Loading parcel details...',
                        style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      children: [
                        // ── Route Card ────────────────────────
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
                                  Row(
                                    children: [
                                      Image.asset(AppImages.greenDot, width: 12, height: 12),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          height: 40,
                                          child: TextField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                                text: b.pickupLocation.address),
                                            style: const TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.black,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(horizontal: 10),
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 28, right: 10, top: 5, bottom: 5),
                                    height: 1,
                                    color: AppColors.grey,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(AppImages.redDot, width: 12, height: 12),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          height: 40,
                                          child: TextField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                                text: b.dropoffLocation.address),
                                            style: const TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.black,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(horizontal: 10),
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

                        // ── Status banner ─────────────────────
                        if (b.isActive)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            color: _statusColor(b.rideStatus),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Text(
                              _statusLabel(b.rideStatus),
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                color: AppColors.black,
                              ),
                            ),
                          ),

                        // ── Divider ───────────────────────────
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 1,
                          color: AppColors.grey,
                        ),

                        if (b.isActive) const SizedBox(height: 10),

                        // ── Driver Card ───────────────────────
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
                                  Image.asset(AppImages.parcel,
                                      width: 40, height: 40, fit: BoxFit.contain),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                            b.driver.vehicleNo.isNotEmpty
                                                ? _formatVehicleNo(b.driver.vehicleNo)
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
                                        Row(
                                          children: [
                                            Text(
                                              b.driver.driverName.isNotEmpty
                                                  ? b.driver.driverName
                                                  : 'Searching...',
                                              style: const TextStyle(
                                                fontFamily: 'Urbanist',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.black,
                                              ),
                                            ),
                                            if (b.driver.driverRating.isNotEmpty) ...[
                                              const SizedBox(width: 15),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.lightGreen,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      b.driver.driverRating,
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

                                  // Call button (only when active)
                                  if (b.isActive)
                                    GestureDetector(
                                      onTap: () => _callDriver(b.driver.driverNo),
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

                        // ── Bottom row: warning + cancel ──────
                        if (b.isActive)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
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
                                              AppStrings.parcelCancelBtn,
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
          );
        },
      ),
    );
  }
}
