import 'package:flutter/material.dart';
import '../core/storage/hive_service.dart';
import '../model/address/address_model.dart';
import '../repo/address_repo.dart';
import '../services/network/api_error_mapper.dart';
import '../services/network/response/api_response.dart';

class AddressProvider extends ChangeNotifier {
  final _repo = AddressRepo();

  ApiResponse<List<AddressData>> addresses = ApiResponse.idle();

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
          : ApiResponse.error(res.message.isNotEmpty ? res.message : 'Failed to load addresses');
    } catch (e) {
      addresses = ApiErrorMapper.map(e);
    }
    notifyListeners();
  }
}
