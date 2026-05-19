import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/storage/hive_service.dart';
import '../../model/address/address_model.dart';
import '../../provider/address_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../utils/custom_app_button.dart';

class AddAddressScreen extends StatefulWidget {
  final AddressData? addressData;

  const AddAddressScreen({super.key, this.addressData});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  String _addressType = 'Home';
  bool _isLoading = false;

  // Map state
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng _markerPosition = const LatLng(20.5937, 78.9629); // India center
  Marker? _marker;
  String _apiAddressText = '';

  bool get _isEdit => widget.addressData != null;

  static const List<String> _addressTypes = ['Home', 'Office', 'Favourite'];

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final d = widget.addressData!;
      _addressController.text = d.address;
      _zipController.text = d.zipCode;
      _cityController.text = d.city;
      _addressType = _addressTypes.contains(d.addressType) ? d.addressType : 'Home';
      final lat = double.tryParse(d.lat) ?? 20.5937;
      final lng = double.tryParse(d.lng) ?? 78.9629;
      _markerPosition = LatLng(lat, lng);
      _apiAddressText = d.address;
      _placeMarker(_markerPosition);
    } else {
      _initCurrentLocation();
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _initCurrentLocation() async {
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      final latLng = LatLng(pos.latitude, pos.longitude);
      _markerPosition = latLng;
      if (mounted) setState(() {});
      final ctrl = await _mapController.future;
      ctrl.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    } catch (_) {}
  }

  Future<void> _onMapTap(LatLng latLng) async {
    _markerPosition = latLng;
    _placeMarker(latLng);

    // Reverse geocode
    try {
      final marks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (marks.isNotEmpty && mounted) {
        final p = marks.first;
        final addr = [p.street, p.subLocality, p.locality, p.postalCode, p.country]
            .where((s) => s != null && s.isNotEmpty)
            .join(', ');
        setState(() => _apiAddressText = addr);
      }
    } catch (_) {
      if (mounted) setState(() => _apiAddressText = 'Tap to fetch address');
    }
  }

  void _placeMarker(LatLng pos) {
    setState(() {
      _marker = Marker(
        markerId: const MarkerId('selected'),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
  }

  Future<void> _save() async {
    final address = _addressController.text.trim();
    final zip = _zipController.text.trim();
    final city = _cityController.text.trim();

    if (address.isEmpty) { _showSnack('Address is required'); return; }
    if (zip.isEmpty) { _showSnack('Zipcode is required'); return; }
    if (city.isEmpty) { _showSnack('City is required'); return; }

    setState(() => _isLoading = true);

    final d = DateTime.now();
    String pad(int n) => n.toString().padLeft(2, '0');
    final now = '${d.year}-${pad(d.month)}-${pad(d.day)}T${pad(d.hour)}:${pad(d.minute)}:${pad(d.second)}';
    final userId = int.tryParse(HiveService.getUserId() ?? '0') ?? 0;

    final request = AddAddressRequest(
      pkAddressId: _isEdit ? widget.addressData!.pkAddressId : 0,
      fkUserId: userId,
      userName: HiveService.getFullName(),
      email: HiveService.getEmail() ?? '',
      phoneNo: HiveService.getMobileNo() ?? '',
      address: address,
      zipCode: zip,
      city: city,
      lat: _markerPosition.latitude.toString(),
      lng: _markerPosition.longitude.toString(),
      apiAddress: _apiAddressText.isNotEmpty ? _apiAddressText : address,
      addressType: _addressType,
      createdDate: now,
    );

    final provider = context.read<AddressProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final success = await provider.addAddress(request);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      messenger.showSnackBar(SnackBar(
          content: Text(_isEdit ? 'Address updated successfully' : 'Address saved successfully')));
      navigator.pop();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(provider.actionError)));
    }
  }

  Future<void> _delete() async {
    final provider = context.read<AddressProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Address',
            style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this address?',
            style: TextStyle(fontFamily: 'Urbanist')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: AppColors.red))),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    final success = await provider.deleteAddress(widget.addressData!.pkAddressId);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      messenger.showSnackBar(const SnackBar(content: Text('Address deleted')));
      navigator.pop();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(provider.actionError)));
    }
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 50,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(AppImages.backBtn),
          ),
        ),
        centerTitle: true,
        title: Text(
          _isEdit ? 'Update Address' : 'Add Address',
          style: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Map Section (45% of body) ──────────────────
          Expanded(
            flex: 9,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _markerPosition,
                    zoom: 13,
                  ),
                  onMapCreated: (ctrl) => _mapController.complete(ctrl),
                  markers: _marker != null ? {_marker!} : {},
                  onTap: _onMapTap,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
                // ── Address overlay at bottom of map ────
                if (_apiAddressText.isNotEmpty)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _apiAddressText,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 8,
                          color: Colors.black,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Form Section (55% of body) ─────────────────
          Expanded(
            flex: 11,
            child: Column(
              children: [
                // Hint text
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Tap anywhere on map to set address!',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      color: AppColors.gray,
                    ),
                  ),
                ),

                // ── Address (multiline, 80dp) ────────────
                _FieldRow(
                  icon: AppImages.addressHome,
                  iconSize: 26,
                  height: 80,
                  alignIconTop: true,
                  child: TextField(
                    controller: _addressController,
                    maxLines: 3,
                    minLines: 2,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    style: _fieldStyle,
                    decoration: _decoration('Enter your address'),
                  ),
                ),

                const SizedBox(height: 5),

                // ── ZipCode ──────────────────────────────
                _FieldRow(
                  icon: AppImages.zipcode,
                  iconSize: 26,
                  height: 50,
                  child: TextField(
                    controller: _zipController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: _fieldStyle,
                    decoration: _decoration('Enter your zipcode'),
                  ),
                ),

                const SizedBox(height: 5),

                // ── City ─────────────────────────────────
                _FieldRow(
                  icon: AppImages.map,
                  iconSize: 26,
                  height: 50,
                  child: TextField(
                    controller: _cityController,
                    textCapitalization: TextCapitalization.words,
                    style: _fieldStyle,
                    decoration: _decoration('Enter your city'),
                  ),
                ),

                const SizedBox(height: 5),

                // ── Address Type Dropdown ─────────────────
                _FieldRow(
                  icon: AppImages.viewMore,
                  iconSize: 36,
                  height: 50,
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Image.asset(AppImages.dropdown, width: 22, height: 22),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _addressType,
                      isExpanded: true,
                      style: _fieldStyle,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      icon: const SizedBox.shrink(),
                      items: _addressTypes
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) => setState(() => _addressType = v!),
                    ),
                  ),
                ),

                const Spacer(),

                // ── Footer Buttons ────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Row(
                    children: [
                      if (_isEdit) ...[
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _delete,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: AppColors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: CustomAppButton(
                          title: 'Save Settings',
                          isLoading: _isLoading,
                          onPressed: _save,
                          buttonHeight: 50,
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
  }

  static const TextStyle _fieldStyle = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static InputDecoration _decoration(String hint) => InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.gray,
        ),
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        isDense: true,
      );
}

class _FieldRow extends StatelessWidget {
  final String icon;
  final double iconSize;
  final double height;
  final Widget child;
  final Widget? suffix;
  final bool alignIconTop;

  const _FieldRow({
    required this.icon,
    required this.iconSize,
    required this.height,
    required this.child,
    this.suffix,
    this.alignIconTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: AppColors.white,
      child: Row(
        crossAxisAlignment:
            alignIconTop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: alignIconTop ? 14 : 0),
            child: SizedBox(
              width: iconSize,
              child: Image.asset(icon, height: iconSize, fit: BoxFit.contain),
            ),
          ),
          Expanded(child: child),
          ?suffix,
        ],
      ),
    );
  }
}
