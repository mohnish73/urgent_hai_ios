import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';

class LocateMeScreen extends StatefulWidget {
  const LocateMeScreen({super.key});

  @override
  State<LocateMeScreen> createState() => _LocateMeScreenState();
}

class _LocateMeScreenState extends State<LocateMeScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  String _selectedAddress = '';
  bool _sheetVisible = false;
  bool _loadingAddress = false;

  static const LatLng _defaultCenter = LatLng(20.5937, 78.9629);

  @override
  void initState() {
    super.initState();
    _goToCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _goToCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }
      final pos = await Geolocator.getCurrentPosition();
      final latLng = LatLng(pos.latitude, pos.longitude);
      _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 15.0));
    } catch (_) {}
  }

  Future<void> _onMapTap(LatLng latLng) async {
    setState(() {
      _selectedLatLng = latLng;
      _sheetVisible = false;
      _loadingAddress = true;
    });

    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      final p = placemarks.isNotEmpty ? placemarks.first : null;
      final address = p != null
          ? [p.street, p.locality, p.administrativeArea, p.country]
              .where((s) => s != null && s.isNotEmpty)
              .join(', ')
          : 'No address found';

      setState(() {
        _selectedAddress = address;
        _loadingAddress = false;
        _sheetVisible = true;
      });
    } catch (_) {
      setState(() {
        _selectedAddress = 'Unable to get address';
        _loadingAddress = false;
        _sheetVisible = true;
      });
    }
  }

  void _onConfirm() {
    if (_selectedLatLng == null) return;
    context.pop({
      'address': _selectedAddress,
      'lat': _selectedLatLng!.latitude,
      'lng': _selectedLatLng!.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Full-screen Google Map ─────────────────────────
          GoogleMap(
            onMapCreated: (c) {
              _mapController = c;
              _goToCurrentLocation();
            },
            initialCameraPosition: const CameraPosition(
              target: _defaultCenter,
              zoom: 5,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onTap: _onMapTap,
            markers: _selectedLatLng != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLatLng!,
                    ),
                  }
                : {},
          ),

          // ── Back button (top-left, 32dp, margin 16dp) ─────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Image.asset(AppImages.back, width: 32, height: 32),
              ),
            ),
          ),

          // ── Loading indicator while geocoding ─────────────
          if (_loadingAddress)
            const Center(child: CircularProgressIndicator(color: AppColors.primary)),

          // ── Bottom sheet: address + Confirm button ─────────
          if (_sheetVisible)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, -2))
                  ],
                ),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.greyBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // "Selected Address :" label
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Selected Address :',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          color: AppColors.gray,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Address text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '📍 $_selectedAddress',
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Confirm Location button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            'Confirm Location',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w700,
                            ),
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
    );
  }
}
