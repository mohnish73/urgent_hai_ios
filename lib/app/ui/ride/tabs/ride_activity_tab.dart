import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_history_model.dart';
import '../../../provider/ride_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';
import '../../../utils/widgets/api_state_builder.dart';

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
      builder: (_, provider, __) => ApiStateBuilder<List<RideHistoryData>>(
        response: provider.rideHistory,
        onRetry: () => provider.fetchRideHistory(),
        idleWidget: _EmptyState(
          image: AppImages.gifRide,
          message: 'No ride history yet.',
        ),
        builder: (rides) => rides.isEmpty
            ? _EmptyState(image: AppImages.gifRide, message: 'No ride history yet.')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: rides.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => _RideHistoryCard(ride: rides[i]),
              ),
      ),
    );
  }
}

class _RideHistoryCard extends StatelessWidget {
  final RideHistoryData ride;
  const _RideHistoryCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicator
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ride.isActive ? AppColors.primary : AppColors.gray,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pickup → Drop
                Row(
                  children: [
                    Image.asset(AppImages.pinGreen, width: 14, height: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        ride.pickupLocation.address,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Image.asset(AppImages.pinRed, width: 14, height: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        ride.dropoffLocation.address,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13,
                          color: AppColors.gray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      ride.dateTime,
                      style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 11,
                          color: AppColors.gray),
                    ),
                    const Spacer(),
                    Text(
                      '₹${ride.rideTypeFare.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String image;
  final String message;
  const _EmptyState({required this.image, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(image, width: 180, height: 180),
          const SizedBox(height: 12),
          Text(message,
              style: const TextStyle(
                  fontFamily: 'Urbanist',
                  color: AppColors.gray,
                  fontSize: 16)),
        ],
      ),
    );
  }
}
