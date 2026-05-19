import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/storage/hive_service.dart';
import '../../../model/address/address_model.dart';
import '../../../provider/address_provider.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../services/network/response/api_response.dart';
import '../../../theme/app_images.dart';

class AddressTab extends StatefulWidget {
  const AddressTab({super.key});

  @override
  State<AddressTab> createState() => _AddressTabState();
}

class _AddressTabState extends State<AddressTab> {
  String _locationName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().fetchAddresses();
      _fetchCurrentLocation();
    });
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );
      final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (marks.isNotEmpty && mounted) {
        setState(() => _locationName = marks.first.locality ?? '');
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status bar space ──────────────────────────
            SizedBox(height: MediaQuery.of(context).padding.top),

            // ── Header: Location + Profile Pic ────────────
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(AppImages.location, width: 24, height: 24),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _locationName.isNotEmpty ? _locationName : '...',
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              'India',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                    (HiveService.getProfilePic()?.isNotEmpty ?? false)
                        ? AppImages.samplePic
                        : AppImages.samplePic,
                  ),
                  backgroundColor: AppColors.lightGreen,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── "My Favourites" title row ──────────────────
            Row(
              children: [
                Image.asset(
                  AppImages.address,
                  width: 22,
                  height: 22,
                  color: AppColors.red,
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'My Favourites',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final provider = context.read<AddressProvider>();
                    await context.push(AppRoutes.addAddress);
                    if (mounted) provider.fetchAddresses();
                  },
                  child: Image.asset(AppImages.add, width: 22, height: 22),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Address List ───────────────────────────────
            Expanded(
              child: Consumer<AddressProvider>(
                builder: (_, provider, __) {
                  final resp = provider.addresses;

                  if (resp.status == ApiStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (resp.status == ApiStatus.success &&
                      resp.data != null &&
                      resp.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: resp.data!.length,
                      itemBuilder: (_, i) => _AddressCard(
                        address: resp.data![i],
                        onTap: () async {
                          final provider = context.read<AddressProvider>();
                          await context.push(AppRoutes.addAddress, extra: resp.data![i]);
                          if (mounted) provider.fetchAddresses();
                        },
                      ),
                    );
                  }

                  // ── Empty State ────────────────────────
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.gifNoDataFound,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Still empty here!\nAdd your address above to get started 👆',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressData address;
  final VoidCallback onTap;

  const _AddressCard({required this.address, required this.onTap});

  String get _icon {
    switch (address.addressType.toLowerCase()) {
      case 'home':
        return AppImages.addressHome;
      case 'office':
        return AppImages.office;
      default:
        return AppImages.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                _icon,
                width: 28,
                height: 28,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.addressType.isNotEmpty
                          ? address.addressType
                          : 'Address',
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F3F3F),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address.address,
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        color: Color(0xFF3F3F3F),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
