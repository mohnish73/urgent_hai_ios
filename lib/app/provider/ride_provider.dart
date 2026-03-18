import 'package:flutter/material.dart';
import '../core/storage/hive_service.dart';
import '../model/ride/ride_history_model.dart';
import '../repo/ride_repo.dart';
import '../services/network/api_error_mapper.dart';
import '../services/network/response/api_response.dart';

class RideProvider extends ChangeNotifier {
  final _repo = RideRepo();

  ApiResponse<List<RideHistoryData>> rideHistory = ApiResponse.idle();
  ApiResponse<List<RideHistoryData>> parcelHistory = ApiResponse.idle();

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
