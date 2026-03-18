import 'package:flutter/material.dart';
import '../core/storage/hive_service.dart';
import '../model/ride/book_ride_model.dart'; // BookRideData, CheckBookingData
import '../model/ride/ride_history_model.dart';
import '../model/ride/ride_type_model.dart';
import '../repo/ride_repo.dart';
import '../services/network/api_error_mapper.dart';
import '../services/network/response/api_response.dart';

class RideProvider extends ChangeNotifier {
  final _repo = RideRepo();

  // ─── Ride Types ───────────────────────────────────────
  ApiResponse<List<RideTypeData>> rideTypes = ApiResponse.idle();

  // ─── Booking ──────────────────────────────────────────
  ApiResponse<BookRideData> bookingState = ApiResponse.idle();
  BookRideData? activeBooking;

  // ─── History ──────────────────────────────────────────
  ApiResponse<List<RideHistoryData>> rideHistory = ApiResponse.idle();
  ApiResponse<List<RideHistoryData>> parcelHistory = ApiResponse.idle();

  // ─── Ride Types ───────────────────────────────────────
  Future<void> fetchRideTypes({
    required String userId,
    required String mobileNo,
    required String pickupAddress,
    required double pickupLat,
    required double pickupLng,
    required String dropAddress,
    required double dropLat,
    required double dropLng,
  }) async {
    rideTypes = ApiResponse.loading();
    notifyListeners();

    try {
      final res = await _repo.fetchRideTypes(
        userId: userId,
        mobileNo: mobileNo,
        pickupAddress: pickupAddress,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropAddress: dropAddress,
        dropLat: dropLat,
        dropLng: dropLng,
      );
      rideTypes = res.result
          ? ApiResponse.success(res.data)
          : ApiResponse.error(res.message.isNotEmpty ? res.message : 'Failed to load ride types');
    } catch (e) {
      rideTypes = ApiErrorMapper.map(e);
    }
    notifyListeners();
  }

  // ─── Book Ride ────────────────────────────────────────
  Future<BookRideData?> bookRide(BookRideRequestModel request) async {
    bookingState = ApiResponse.loading();
    notifyListeners();

    try {
      final res = await _repo.bookRide(request);
      if (res.result && res.data != null) {
        activeBooking = res.data;
        bookingState = ApiResponse.success(res.data!);
        notifyListeners();
        return res.data;
      } else {
        bookingState = ApiResponse.error(res.message.isNotEmpty ? res.message : 'Booking failed');
        notifyListeners();
        return null;
      }
    } catch (e) {
      bookingState = ApiErrorMapper.map(e);
      notifyListeners();
      return null;
    }
  }

  // ─── Check Booking (polls by tempRideBookId) ─────────
  Future<CheckBookingData?> checkBooking(String tempRideBookId) async {
    try {
      final res = await _repo.checkBooking(tempRideBookId);
      return res.data;
    } catch (_) {
      return null;
    }
  }

  // ─── Cancel Ride (confirmed booking) ─────────────────
  Future<bool> cancelRide(int riderBook) async {
    final userId = HiveService.getUserId();
    if (userId == null) return false;

    try {
      final ok = await _repo.cancelRide(userId, riderBook);
      if (ok) {
        activeBooking = null;
        bookingState = ApiResponse.idle();
        notifyListeners();
      }
      return ok;
    } catch (_) {
      return false;
    }
  }

  // ─── Cancel Ride (temp / searching) ──────────────────
  Future<bool> cancelRideTemp(String tempRideBookId) async {
    final userId = HiveService.getUserId();
    if (userId == null) return false;

    try {
      final ok = await _repo.cancelRideTemp(userId, tempRideBookId);
      if (ok) {
        activeBooking = null;
        bookingState = ApiResponse.idle();
        notifyListeners();
      }
      return ok;
    } catch (_) {
      return false;
    }
  }

  void resetBooking() {
    bookingState = ApiResponse.idle();
    activeBooking = null;
    notifyListeners();
  }

  // ─── Ride History ─────────────────────────────────────
  Future<void> fetchRideHistory() async {
    final userId = HiveService.getUserId();
    if (userId == null) return;

    rideHistory = ApiResponse.loading();
    notifyListeners();

    try {
      final res = await _repo.fetchRideHistory(userId);
      rideHistory = res.result
          ? ApiResponse.success(res.data)
          : ApiResponse.error(res.message.isNotEmpty ? res.message : 'Failed to load ride history');
    } catch (e) {
      rideHistory = ApiErrorMapper.map(e);
    }
    notifyListeners();
  }

  // ─── Parcel History ───────────────────────────────────
  Future<void> fetchParcelHistory() async {
    final userId = HiveService.getUserId();
    if (userId == null) return;

    parcelHistory = ApiResponse.loading();
    notifyListeners();

    try {
      final res = await _repo.fetchParcelHistory(userId);
      parcelHistory = res.result
          ? ApiResponse.success(res.data)
          : ApiResponse.error(res.message.isNotEmpty ? res.message : 'Failed to load parcel history');
    } catch (e) {
      parcelHistory = ApiErrorMapper.map(e);
    }
    notifyListeners();
  }
}
