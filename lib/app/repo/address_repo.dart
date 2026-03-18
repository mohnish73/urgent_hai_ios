import '../core/config/app_config.dart';
import '../model/address/address_model.dart';
import '../services/network/network_api_services.dart';

class AddressRepo {
  final _api = NetworkApiServices();

  Future<AddressListResponse> fetchAddresses({
    required String userId,
    required String mobileNo,
  }) async {
    final res = await _api.getApi(
      '${AppConfig.baseUrl}URGH/GetUserAddressList?Id=$userId&Mobile_No=$mobileNo',
    );
    return AddressListResponse.fromJson(res.data);
  }
}
