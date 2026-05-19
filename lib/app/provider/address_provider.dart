import 'package:flutter/material.dart';
import '../core/storage/hive_service.dart';
import '../model/address/address_model.dart';
import '../repo/address_repo.dart';
import '../services/network/api_error_mapper.dart';
import '../services/network/response/api_response.dart';

class AddressProvider extends ChangeNotifier {
  final _repo = AddressRepo();

  ApiResponse<List<AddressData>> addresses = ApiResponse.idle();

  bool _isActionLoading = false;
  String _actionError = '';

  bool get isActionLoading => _isActionLoading;
  String get actionError => _actionError;

  // ─── Fetch List ───────────────────────────────────────
  Future<void> fetchAddresses() async {
    final userId = HiveService.getUserId();
    final mobileNo = HiveService.getMobileNo();
    if (userId == null || mobileNo == null) return;

    addresses = ApiResponse.loading();
    notifyListeners();

    try {
      final res = await _repo.fetchAddresses(userId: userId, mobileNo: mobileNo);
      addresses = res.result
          ? ApiResponse.success(res.data)
          : ApiResponse.error(
              res.message.isNotEmpty ? res.message : 'Failed to load addresses');
    } catch (e) {
      addresses = ApiErrorMapper.map(e);
    }
    notifyListeners();
  }

  // ─── Add / Update Address ─────────────────────────────
  Future<bool> addAddress(AddAddressRequest request) async {
    _isActionLoading = true;
    _actionError = '';
    notifyListeners();

    try {
      final res = await _repo.addAddress(request);
      if (res.result) {
        await fetchAddresses();
        _isActionLoading = false;
        notifyListeners();
        return true;
      } else {
        _actionError = res.message.isNotEmpty ? res.message : 'Failed to save address';
        _isActionLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _actionError = 'Something went wrong. Please try again.';
      _isActionLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ─── Delete Address ───────────────────────────────────
  Future<bool> deleteAddress(int addressId) async {
    _isActionLoading = true;
    _actionError = '';
    notifyListeners();

    try {
      final userId = HiveService.getUserId() ?? '';
      final mobileNo = HiveService.getMobileNo() ?? '';
      final res = await _repo.deleteAddress(
        addressId: addressId.toString(),
        userId: userId,
        mobileNo: mobileNo,
      );
      if (res.result) {
        await fetchAddresses();
        _isActionLoading = false;
        notifyListeners();
        return true;
      } else {
        _actionError = res.message.isNotEmpty ? res.message : 'Failed to delete address';
        _isActionLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _actionError = 'Something went wrong. Please try again.';
      _isActionLoading = false;
      notifyListeners();
      return false;
    }
  }
}
