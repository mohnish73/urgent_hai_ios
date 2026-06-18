import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/storage/hive_service.dart';
import '../../model/parcel/parcel_model.dart';
import '../../model/ride/book_ride_model.dart';
import '../../model/ride/ride_type_model.dart';
import '../../provider/ride_provider.dart';
import '../../routes/app_router.dart';
import '../../services/network/response/global_error_handle.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';

const _orsApiKey =
    'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjBiYzdkNDNlZjdjYzQ4YWY4MjFjZmNlODMzM2FjNDU2IiwiaCI6Im11cm11cjY0In0=';

const _searchMessages = [
  '🔍 Searching for a delivery partner near you...',
  '🚚 Hold on, we\'re matching you with a nearby courier.',
  '🛣️ Checking the best route for your delivery.',
  '🧑‍✈️ Verifying courier availability in your area.',
  '🕒 Please wait a moment while we find the best match.',
  '📍 Optimizing your pickup location for delivery...',
  '🚦 Your delivery partner will follow all safety guidelines.',
  '📝 Ensure your pickup and drop-off details are correct.',
  '📡 Sharing your pickup details with nearby couriers.',
  '❗ Once confirmed, cancellation charges may apply.',
  '✅ Sit tight! You\'ll be notified once your courier is confirmed.',
  '⏳ Still searching… hang tight, almost there!',
  '📲 Keep your phone nearby for delivery updates.',
  '💬 We\'ll notify you as soon as a courier accepts the delivery.',
  '🧾 Your delivery charges will be calculated once confirmed.',
];

class BookParcelScreen extends StatefulWidget {
  final String pickup;
  final String drop;
  final double pickupLat;
  final double pickupLng;
  final double dropLat;
  final double dropLng;
  final ParcelRequestModel parcelRequest;

  const BookParcelScreen({
    super.key,
    required this.pickup,
    required this.drop,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.parcelRequest,
  });

  @override
  State<BookParcelScreen> createState() => _BookParcelScreenState();
}

class _BookParcelScreenState extends State<BookParcelScreen> {
  GoogleMapController? _mapController;
  int _selectedIndex = 0;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Timer? _polylineAnimTimer;

  bool _isSearching = false;
  bool _driverFound = false;
  BookRideData? _tempBooking;

  Timer? _messageTimer;
  int _messageIndex = 0;

  Timer? _pollTimer;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  LatLng get _mapCenter => widget.pickupLat != 0 && widget.pickupLng != 0
      ? LatLng(widget.pickupLat, widget.pickupLng)
      : const LatLng(20.5937, 78.9629);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RideProvider>().fetchParcelTypes(
        userId: HiveService.getUserId() ?? '',
        mobileNo: HiveService.getMobileNo() ?? '',
        pickupAddress: widget.pickup,
        pickupLat: widget.pickupLat,
        pickupLng: widget.pickupLng,
        dropAddress: widget.drop,
        dropLat: widget.dropLat,
        dropLng: widget.dropLng,
      );
    });
  }

  @override
  void dispose() {
    _polylineAnimTimer?.cancel();
    _messageTimer?.cancel();
    _pollTimer?.cancel();
    _mapController?.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  Future<void> _drawRoute() async {
    try {
      final url =
          'https://api.openrouteservice.org/v2/directions/driving-car'
          '?api_key=$_orsApiKey'
          '&start=${widget.pickupLng},${widget.pickupLat}'
          '&end=${widget.dropLng},${widget.dropLat}';

      final resp = await Dio().get(url);
      final coords = resp.data['features'][0]['geometry']['coordinates'] as List;
      final path = coords
          .map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
          .toList();

      if (!mounted || path.isEmpty) return;

      setState(() {
        _markers
          ..clear()
          ..add(Marker(
            markerId: const MarkerId('start'),
            position: path.first,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ))
          ..add(Marker(
            markerId: const MarkerId('end'),
            position: path.last,
          ));
      });

      _animatePolyline(path);

      final bounds = _buildBounds(path);
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
    } catch (_) {
      if (mounted && widget.pickupLat != 0) {
        setState(() {
          _markers
            ..add(Marker(
              markerId: const MarkerId('start'),
              position: LatLng(widget.pickupLat, widget.pickupLng),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            ))
            ..add(Marker(
              markerId: const MarkerId('end'),
              position: LatLng(widget.dropLat, widget.dropLng),
            ));
        });
      }
    }
  }

  void _animatePolyline(List<LatLng> path) {
    const totalMs = 3000;
    const intervalMs = 50;
    final steps = (totalMs / intervalMs).round();
    final pointsPerStep = (path.length / steps).ceil().clamp(1, path.length);
    int currentCount = 0;

    _polylineAnimTimer?.cancel();
    _polylineAnimTimer = Timer.periodic(
      const Duration(milliseconds: intervalMs),
      (timer) {
        currentCount = (currentCount + pointsPerStep).clamp(0, path.length);
        if (mounted) {
          setState(() {
            _polylines
              ..clear()
              ..add(Polyline(
                polylineId: const PolylineId('route'),
                points: path.sublist(0, currentCount),
                color: AppColors.primary,
                width: 5,
              ));
          });
        }
        if (currentCount >= path.length) timer.cancel();
      },
    );
  }

  LatLngBounds _buildBounds(List<LatLng> path) {
    double minLat = path.first.latitude;
    double maxLat = path.first.latitude;
    double minLng = path.first.longitude;
    double maxLng = path.first.longitude;
    for (final p in path) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _onContinue(List<RideTypeData> parcelTypes) async {
    final selected = parcelTypes[_selectedIndex];
    final provider = context.read<RideProvider>();

    final result = await provider.bookParcelRequest(BookRideRequestModel(
      userId: HiveService.getUserId() ?? '',
      mobileNo: HiveService.getMobileNo() ?? '',
      pickupAddress: widget.pickup,
      pickupLat: widget.pickupLat,
      pickupLng: widget.pickupLng,
      dropAddress: widget.drop,
      dropLat: widget.dropLat,
      dropLng: widget.dropLng,
      rideTypeId: selected.rideTypeId,
    ));

    if (!mounted) return;

    if (result != null) {
      setState(() {
        _isSearching = true;
        _driverFound = false;
        _tempBooking = result;
        _messageIndex = 0;
      });
      _startMessages();
      _startPolling(result.tempRideBookId.toString());
    } else {
      GlobalErrorHandler.handle(
        context,
        provider.parcelBookingState,
        onRetry: () => _onContinue(
          context.read<RideProvider>().parcelTypes.data ?? [],
        ),
      );
    }
  }

  void _startMessages() {
    _messageTimer?.cancel();
    _messageTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() => _messageIndex = (_messageIndex + 1) % _searchMessages.length);
      }
    });
  }

  void _startPolling(String tempId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (!mounted) return;
      final data = await context.read<RideProvider>().checkBooking(tempId);
      if (!mounted) return;
      if (data != null && data.isRideBook) {
        _pollTimer?.cancel();
        _messageTimer?.cancel();
        setState(() => _driverFound = true);

        // Save parcel description after driver is confirmed
        widget.parcelRequest.bookingId = data.bookingId;
        await context.read<RideProvider>().saveParcelDescription(widget.parcelRequest);
        if (!mounted) return;

        await Future.delayed(const Duration(milliseconds: 2200));
        if (!mounted) return;

        context.pushReplacement(AppRoutes.parcelDetails,
            extra: {'bookingId': data.bookingId});
      }
    });
  }

  Future<void> _onCancelSearch() async {
    _pollTimer?.cancel();
    _messageTimer?.cancel();
    if (_tempBooking != null) {
      await context.read<RideProvider>()
          .cancelParcelTemp(_tempBooking!.tempRideBookId.toString());
    }
    if (mounted) {
      setState(() {
        _isSearching = false;
        _driverFound = false;
        _tempBooking = null;
      });
    }
  }

  void _toggleSheet() {
    if (!_sheetController.isAttached) return;
    if (_sheetController.size < 0.6) {
      _sheetController.animateTo(
        0.88,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _sheetController.animateTo(
        0.38,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
              if (widget.pickupLat != 0 && widget.pickupLng != 0) {
                c.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(widget.pickupLat, widget.pickupLng),
                  14,
                ));
              }
              if (widget.pickupLat != 0 && widget.dropLat != 0) {
                _drawRoute();
              }
            },
            initialCameraPosition: CameraPosition(target: _mapCenter, zoom: 14),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: _markers,
            polylines: _polylines,
          ),

          // ── Back button ───────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Image.asset(AppImages.back, width: 32, height: 32),
              ),
            ),
          ),

          // ── Sheet 1: Parcel type options ───────────────────
          if (!_isSearching) _buildDraggableSheet1(),

          // ── Sheet 2: Searching ────────────────────────────
          if (_isSearching)
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildSheet2(),
            ),
        ],
      ),
    );
  }

  Widget _buildDraggableSheet1() {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.38,
      minChildSize: 0.33,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.38, 0.88],
      builder: (context, scrollController) {
        return Consumer<RideProvider>(
          builder: (_, provider, __) {
            final response = provider.parcelTypes;
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 10,
                      offset: Offset(0, -2))
                ],
              ),
              child: Column(
                children: [
                  // Drag handle
                  GestureDetector(
                    onTap: _toggleSheet,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.greyBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  if (response.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  else if (response.isSuccess && response.data != null) ...[
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        itemCount: response.data!.length,
                        itemBuilder: (_, i) => _ParcelTypeCard(
                          parcelType: response.data![i],
                          isSelected: _selectedIndex == i,
                          onTap: () => setState(() => _selectedIndex = i),
                        ),
                      ),
                    ),

                    // Bottom row: hint + Continue button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              "You're just one step away from sending your parcel.",
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 9,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () => _onContinue(response.data!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                margin: const EdgeInsets.only(right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Continue',
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
                  ] else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      child: Column(
                        children: [
                          const Text('Failed to load parcel types',
                              style: TextStyle(fontFamily: 'Urbanist', color: AppColors.gray)),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () =>
                                context.read<RideProvider>().fetchParcelTypes(
                                  userId: HiveService.getUserId() ?? '',
                                  mobileNo: HiveService.getMobileNo() ?? '',
                                  pickupAddress: widget.pickup,
                                  pickupLat: widget.pickupLat,
                                  pickupLng: widget.pickupLng,
                                  dropAddress: widget.drop,
                                  dropLat: widget.dropLat,
                                  dropLng: widget.dropLng,
                                ),
                            child: const Text('Retry',
                                style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSheet2() {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, -2))
        ],
      ),
      child: Column(
        children: [
          // Drag handle (visual only)
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: AppColors.greyBorder,
                borderRadius: BorderRadius.circular(2)),
          ),

          // Animated search message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) {
                final slideIn = Tween<Offset>(
                        begin: const Offset(-1, 0), end: Offset.zero)
                    .animate(anim);
                return SlideTransition(position: slideIn, child: child);
              },
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  _searchMessages[_messageIndex],
                  key: ValueKey(_messageIndex),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ),

          // GIF: delivery → green_tick
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Image.asset(
                _driverFound ? AppImages.gifGreenTick : AppImages.gifDelivery,
                key: ValueKey(_driverFound),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Cancel button
          if (!_driverFound)
            GestureDetector(
              onTap: _onCancelSearch,
              child: Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.black, width: 1),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Cancel Parcel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Parcel Type Card ──────────────────────────────────────────
class _ParcelTypeCard extends StatelessWidget {
  final RideTypeData parcelType;
  final bool isSelected;
  final VoidCallback onTap;

  const _ParcelTypeCard({
    required this.parcelType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: isSelected ? AppColors.lightGreen : AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Row(
                children: [
                  Image.asset(
                    AppImages.parcel,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parcelType.rideTypeName,
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          parcelType.rideTypeDesc.isNotEmpty
                              ? parcelType.rideTypeDesc
                              : 'Fast & secure delivery',
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 10,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${parcelType.rideTypeFare.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${parcelType.rideTypeSeats} seats',
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 10,
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
      ),
    );
  }
}
