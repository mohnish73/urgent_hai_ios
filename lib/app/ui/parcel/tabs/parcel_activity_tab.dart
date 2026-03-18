import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_history_model.dart';
import '../../../provider/ride_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';
import '../../../utils/widgets/api_state_builder.dart';

class ParcelActivityTab extends StatefulWidget {
  const ParcelActivityTab({super.key});

  @override
  State<ParcelActivityTab> createState() => _ParcelActivityTabState();
}

class _ParcelActivityTabState extends State<ParcelActivityTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RideProvider>().fetchParcelHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideProvider>(
      builder: (_, provider, __) => ApiStateBuilder<List<RideHistoryData>>(
        response: provider.parcelHistory,
        onRetry: () => provider.fetchParcelHistory(),
        idleWidget: _EmptyState(
          image: AppImages.gifDelivery,
          message: 'No parcel history yet.',
        ),
        builder: (parcels) => parcels.isEmpty
            ? _EmptyState(image: AppImages.gifDelivery, message: 'No parcel history yet.')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: parcels.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => _ParcelHistoryCard(parcel: parcels[i]),
              ),
      ),
    );
  }
}

class _ParcelHistoryCard extends StatelessWidget {
  final RideHistoryData parcel;
  const _ParcelHistoryCard({required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: parcel.isActive ? AppColors.primary : AppColors.gray,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(AppImages.pinGreen, width: 14, height: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        parcel.pickupLocation.address,
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
                        parcel.dropoffLocation.address,
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
                      parcel.dateTime,
                      style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 11,
                          color: AppColors.gray),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: parcel.isActive
                            ? AppColors.lightGreen
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        parcel.rideStatus,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: parcel.isActive
                              ? AppColors.primary
                              : AppColors.gray,
                        ),
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
