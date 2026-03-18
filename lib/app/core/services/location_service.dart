import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme/app_strings.dart';

class LocationResult {
  final String city;
  final String country;
  final double lat;
  final double lng;

  const LocationResult({
    required this.city,
    required this.country,
    required this.lat,
    required this.lng,
  });
}

class LocationService {
  LocationService._();

  /// Requests permission if needed, fetches current position and
  /// reverse-geocodes it. Returns null if permission denied or error.
  static Future<LocationResult?> fetchCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );
      return _reverseGeocode(position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }

  static Future<LocationResult?> _reverseGeocode(
      double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) {
        return LocationResult(city: '', country: AppStrings.defaultCountry, lat: lat, lng: lng);
      }

      final p = placemarks[0];
      final subLocality = p.subLocality ?? '';
      final adminArea = p.administrativeArea ?? '';
      final country = p.country ?? AppStrings.defaultCountry;

      final city = subLocality.isNotEmpty && adminArea.isNotEmpty
          ? '$subLocality, $adminArea'
          : adminArea.isNotEmpty
              ? adminArea
              : AppStrings.locationNotFound;

      return LocationResult(city: city, country: country, lat: lat, lng: lng);
    } catch (_) {
      return LocationResult(city: '', country: AppStrings.defaultCountry, lat: lat, lng: lng);
    }
  }
}
