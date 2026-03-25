import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config.dart';
import '../../../core/services/location_service.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';
import '../../../theme/app_strings.dart';

// ── Google Places suggestion model ────────────────────────────
class _PlaceSuggestion {
  final String description;
  final String placeId;
  _PlaceSuggestion({required this.description, required this.placeId});
}

class RideBookTab extends StatefulWidget {
  const RideBookTab({super.key});

  @override
  State<RideBookTab> createState() => _RideBookTabState();
}

class _RideBookTabState extends State<RideBookTab> {
  String _locCity = '';
  String _locCountry = AppStrings.defaultCountry;

  final _pickupCtrl = TextEditingController();
  final _dropCtrl = TextEditingController();
  final _pickupFocus = FocusNode();
  final _dropFocus = FocusNode();

  // Pickup location coordinates
  double _pickupLat = 0.0;
  double _pickupLng = 0.0;
  // Drop location coordinates
  double _dropLat = 0.0;
  double _dropLng = 0.0;

  // Suggestions state
  List<_PlaceSuggestion> _suggestions = [];
  bool _activeFieldIsPickup = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _pickupFocus.addListener(_onFocusChange);
    _dropFocus.addListener(_onFocusChange);
    _pickupCtrl.addListener(_onPickupTextChanged);
    _dropCtrl.addListener(_onDropTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _pickupCtrl.removeListener(_onPickupTextChanged);
    _dropCtrl.removeListener(_onDropTextChanged);
    _pickupFocus.removeListener(_onFocusChange);
    _dropFocus.removeListener(_onFocusChange);
    _pickupCtrl.dispose();
    _dropCtrl.dispose();
    _pickupFocus.dispose();
    _dropFocus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_pickupFocus.hasFocus) _activeFieldIsPickup = true;
    if (_dropFocus.hasFocus) _activeFieldIsPickup = false;
    if (!_pickupFocus.hasFocus && !_dropFocus.hasFocus) {
      setState(() => _suggestions = []);
    }
  }

  void _onPickupTextChanged() {
    if (_pickupFocus.hasFocus) _fetchSuggestions(_pickupCtrl.text);
  }

  void _onDropTextChanged() {
    if (_dropFocus.hasFocus) _fetchSuggestions(_dropCtrl.text);
  }

  Future<void> _loadLocation() async {
    final result = await LocationService.fetchCurrentLocation();
    if (result != null && mounted) {
      setState(() {
        _locCity = result.city;
        _locCountry = result.country;
        if (_pickupCtrl.text.isEmpty) {
          _pickupCtrl.text =
              result.city.isNotEmpty ? '${result.city}, ${result.country}' : result.country;
          // Also set coordinates so route can be drawn on next screen
          _pickupLat = result.lat;
          _pickupLng = result.lng;
        }
      });
    }
  }

  // ── Google Places Autocomplete ─────────────────────────────
  Future<void> _fetchSuggestions(String input) async {
    _debounce?.cancel();
    if (input.trim().length < 2) {
      setState(() => _suggestions = []);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final resp = await Dio().get(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json',
          queryParameters: {
            'input': input,
            'key': AppConfig.googleMapsApiKey,
            'components': 'country:in',
          },
        );
        debugPrint('Places Autocomplete status: ${resp.data['status']}');
        debugPrint('Places Autocomplete response: ${resp.data}');
        final predictions = (resp.data['predictions'] as List?) ?? [];
        if (mounted) {
          setState(() {
            _suggestions = predictions
                .map((p) => _PlaceSuggestion(
                      description: p['description'] as String,
                      placeId: p['place_id'] as String,
                    ))
                .toList();
          });
        }
      } catch (e, st) {
        debugPrint('Places Autocomplete ERROR: $e');
        debugPrint('Stack: $st');
        if (mounted) setState(() => _suggestions = []);
      }
    });
  }

  // ── Get lat/lng for selected place ────────────────────────
  Future<void> _onSuggestionTap(_PlaceSuggestion s) async {
    FocusScope.of(context).unfocus();
    setState(() => _suggestions = []);

    try {
      final resp = await Dio().get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': s.placeId,
          'fields': 'geometry',
          'key': AppConfig.googleMapsApiKey,
        },
      );
      debugPrint('Place Details status: ${resp.data['status']}');
      debugPrint('Place Details response: ${resp.data}');
      final loc = resp.data['result']['geometry']['location'];
      final lat = (loc['lat'] as num).toDouble();
      final lng = (loc['lng'] as num).toDouble();

      setState(() {
        if (_activeFieldIsPickup) {
          _pickupCtrl.text = s.description;
          _pickupLat = lat;
          _pickupLng = lng;
        } else {
          _dropCtrl.text = s.description;
          _dropLat = lat;
          _dropLng = lng;
        }
      });
    } catch (e, st) {
      debugPrint('Place Details ERROR: $e');
      debugPrint('Stack: $st');
      if (_activeFieldIsPickup) {
        _pickupCtrl.text = s.description;
      } else {
        _dropCtrl.text = s.description;
      }
    }
  }

  // ── Open LocateMeScreen and fill field ────────────────────
  Future<void> _openLocateMe(bool isPickup) async {
    setState(() => _activeFieldIsPickup = isPickup);
    final result = await context.push<Map<String, dynamic>>(AppRoutes.locateMe);
    if (result == null || !mounted) return;

    final address = result['address'] as String? ?? '';
    final lat = (result['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (result['lng'] as num?)?.toDouble() ?? 0.0;

    setState(() {
      if (isPickup) {
        _pickupCtrl.text = address;
        _pickupLat = lat;
        _pickupLng = lng;
      } else {
        _dropCtrl.text = address;
        _dropLat = lat;
        _dropLng = lng;
      }
    });
  }

  void _onSearchRide() {
    final pickup = _pickupCtrl.text.trim();
    final drop = _dropCtrl.text.trim();
    if (pickup.isEmpty || drop.isEmpty) return;
    FocusScope.of(context).unfocus();
    context.push(AppRoutes.bookRide, extra: {
      'pickup': pickup,
      'drop': drop,
      'pickupLat': _pickupLat,
      'pickupLng': _pickupLng,
      'dropLat': _dropLat,
      'dropLng': _dropLng,
    });
  }

  @override
  Widget build(BuildContext context) {
    final showStartLocateMe = _pickupFocus.hasFocus;
    final showEndLocateMe = _dropFocus.hasFocus;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Location row ─────────────────────────────────
            GestureDetector(
              onTap: _loadLocation,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.location, width: 24, height: 24),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _locCity.isNotEmpty ? _locCity : AppStrings.defaultCountry,
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_locCity.isNotEmpty)
                          Text(
                            _locCountry,
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // ── Route card ────────────────────────────────────
            Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                        child: Column(
                          children: [
                            // Start field
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(AppImages.greenDot, width: 8, height: 8),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: SizedBox(
                                    height: 30,
                                    child: TextField(
                                      controller: _pickupCtrl,
                                      focusNode: _pickupFocus,
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
                                          fontSize: 14,
                                          color: AppColors.gray,
                                        ),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        filled: true,
                                        fillColor: AppColors.white,
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 10),
                                        isDense: true,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) =>
                                          FocusScope.of(context).requestFocus(_dropFocus),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Divider
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 28, right: 10, top: 5, bottom: 5),
                              height: 1,
                              color: AppColors.grey,
                            ),

                            // End field
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(AppImages.redDot, width: 8, height: 8),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      controller: _dropCtrl,
                                      focusNode: _dropFocus,
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
                                          fontSize: 14,
                                          color: AppColors.gray,
                                        ),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        filled: true,
                                        fillColor: AppColors.white,
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 10),
                                        isDense: true,
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => _onSearchRide(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Arrow button
                    GestureDetector(
                      onTap: _onSearchRide,
                      child: Image.asset(
                        AppImages.rightArrowImg,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Places layout: Home/Office/Work + Locate me ──
            // Shown when a field is focused (like Android's placesLayout gone→visible)
            if (showStartLocateMe || showEndLocateMe) ...[
              const SizedBox(height: 5),
              Row(
                children: [
                  // Home card
                  _QuickCard(
                    icon: AppImages.addressHome,
                    label: 'Home',
                    onTap: () {},
                  ),
                  const SizedBox(width: 6),
                  // Office card
                  _QuickCard(
                    icon: AppImages.office,
                    label: 'Office',
                    onTap: () {},
                  ),
                  const SizedBox(width: 6),
                  // Locate me card
                  _QuickCard(
                    icon: AppImages.locationCrosshair,
                    label: 'Locate me',
                    iconColor: AppColors.primary,
                    onTap: () => _openLocateMe(showStartLocateMe),
                  ),
                ],
              ),
            ],

            // ── Suggestions list ──────────────────────────────
            if (_suggestions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _suggestions.length,
                  itemBuilder: (_, i) {
                    final s = _suggestions[i];
                    return InkWell(
                      onTap: () => _onSuggestionTap(s),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.locationCrosshair,
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                s.description,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12,
                                  color: AppColors.black,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
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

// ── Quick card (Home / Office / Locate me) ────────────────────
class _QuickCard extends StatelessWidget {
  final String icon;
  final String label;
  final Color? iconColor;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                icon,
                width: 22,
                height: 22,
                color: iconColor,
              ),
              const SizedBox(width: 5),
              Text(
                label,
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
      ),
    );
  }
}
