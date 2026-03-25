import 'package:flutter/material.dart';
import '../core/storage/hive_service.dart';
import '../model/ride/book_ride_model.dart';
import '../model/ride/ride_history_model.dart';
import '../model/ride/ride_type_model.dart';
import '../repo/ride_repo.dart';
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
    rideTypes = await _repo.fetchRideTypes(
      userId: userId,
      mobileNo: mobileNo,
      pickupAddress: pickupAddress,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropAddress: dropAddress,
      dropLat: dropLat,
      dropLng: dropLng,
    );
    notifyListeners();
  }

  // ─── Book Ride ────────────────────────────────────────
  Future<BookRideData?> bookRide(BookRideRequestModel request) async {
    bookingState = ApiResponse.loading();
    notifyListeners();
    bookingState = await _repo.bookRide(request);
    activeBooking = bookingState.data;
    notifyListeners();
    return bookingState.data;
  }

  // ─── Check Booking (polls by tempRideBookId) ─────────
  Future<CheckBookingData?> checkBooking(String tempRideBookId) async {
    final result = await _repo.checkBooking(tempRideBookId);
    return result.data;
  }

  // ─── Cancel Ride (confirmed booking) ─────────────────
  Future<bool> cancelRide(int riderBook) async {
    final userId = HiveService.getUserId();
    if (userId == null) return false;
    final result = await _repo.cancelRide(userId, riderBook);
    if (result.data == true) {
      activeBooking = null;
      bookingState = ApiResponse.idle();
      notifyListeners();
      return true;
    }
    return false;
  }

  // ─── Cancel Ride (temp / searching) ──────────────────
  Future<bool> cancelRideTemp(String tempRideBookId) async {
    final userId = HiveService.getUserId();
    if (userId == null) return false;
    final result = await _repo.cancelRideTemp(userId, tempRideBookId);
    if (result.data == true) {
      activeBooking = null;
      bookingState = ApiResponse.idle();
      notifyListeners();
      return true;
    }
    return false;
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
    rideHistory = await _repo.fetchRideHistory(userId);
    notifyListeners();
  }

  // ─── Parcel History ───────────────────────────────────
  Future<void> fetchParcelHistory() async {
    final userId = HiveService.getUserId();
    if (userId == null) return;
    parcelHistory = ApiResponse.loading();
    notifyListeners();
    parcelHistory = await _repo.fetchParcelHistory(userId);
    notifyListeners();
  }
}
