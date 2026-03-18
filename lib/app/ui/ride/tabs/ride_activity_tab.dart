import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_history_model.dart';
import '../../../provider/ride_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';

class RideActivityTab extends StatefulWidget {
  const RideActivityTab({super.key});

  @override
  State<RideActivityTab> createState() => _RideActivityTabState();
}

class _RideActivityTabState extends State<RideActivityTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RideProvider>().fetchRideHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideProvider>(
      builder: (_, provider, __) {
        final response = provider.rideHistory;

        if (response.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final rides = response.data ?? [];
        final activeRides = rides.where((r) => r.isActive).toList();
        final pastRides = rides.where((r) => !r.isActive).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Upcoming section ────────────────────────────
              const SizedBox(height: 10),
              const Text(
                'Upcoming',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 5),

              if (activeRides.isEmpty)
                _NoDataBox(
                  title: 'No active ride!',
                  subtitle: 'Book Now',
                )
              else
                ...activeRides.map((ride) => _ActiveRideCard(ride: ride)),

              // ── Past section ─────────────────────────────────
              const SizedBox(height: 20),
              const Text(
                'Past',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 5),

              if (pastRides.isEmpty)
                _NoDataBox(title: 'No ride history!', subtitle: null)
              else
                ...pastRides.map((ride) => _PastRideCard(ride: ride)),
            ],
          ),
        );
      },
    );
  }
}

// ── "No data" bordered box ────────────────────────────────────
class _NoDataBox extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _NoDataBox({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.black, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: AppColors.black,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
            Text(
              subtitle!,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Active ride card (listitem_active_rides.xml) ──────────────
class _ActiveRideCard extends StatelessWidget {
  final RideHistoryData ride;
  const _ActiveRideCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: date (left) + green dot + "Active" (right)
            Row(
              children: [
                Expanded(
                  child: Text(
                    ride.dateTime,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Image.asset(AppImages.greenDot, width: 12, height: 12),
                    const SizedBox(width: 5),
                    const Text(
                      'Active',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Row 2: drop address (left) + auto icon 40dp (right)
            Row(
              children: [
                Expanded(
                  child: Text(
                    ride.dropoffLocation.address,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Image.asset(AppImages.auto, width: 40, height: 40, fit: BoxFit.contain),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Past ride card (listitem_past_rides.xml) ─────────────────
class _PastRideCard extends StatelessWidget {
  final RideHistoryData ride;
  const _PastRideCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Auto icon 40dp on left
            Image.asset(AppImages.auto, width: 40, height: 40, fit: BoxFit.contain),
            const SizedBox(width: 10),

            // date + drop address + status/fare stacked
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ride.dateTime,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ride.dropoffLocation.address,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ride.rideStatus.isNotEmpty
                        ? '${ride.rideStatus}  ₹${ride.rideTypeFare.toStringAsFixed(0)}'
                        : '₹${ride.rideTypeFare.toStringAsFixed(0)}',
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
          ],
        ),
      ),
    );
  }
}
