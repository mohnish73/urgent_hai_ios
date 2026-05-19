import '../core/config/app_config.dart';
import '../model/address/address_model.dart';
import '../services/network/network_api_services.dart';
import '../services/network/app_url.dart';

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

  Future<AddAddressResponse> addAddress(AddAddressRequest request) async {
    final res = await _api.postApi(request.toJson(), AppUrl.addUserNewAddress);
    return AddAddressResponse.fromJson(res.data);
  }

  Future<AddAddressResponse> deleteAddress({
    required String addressId,
    required String userId,
    required String mobileNo,
  }) async {
    final url =
        '${AppUrl.deleteUserAddress}?PK_AddressId=$addressId&Fk_UserId=$userId&MobileNo=$mobileNo';
    final res = await _api.deleteApiWithToken(url);
    return AddAddressResponse.fromJson(res.data);
  }
}
