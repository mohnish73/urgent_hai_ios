import '../core/config/app_config.dart';
import '../model/ride/ride_history_model.dart';
import '../services/network/network_api_services.dart';

class RideRepo {
  final _api = NetworkApiServices();

  Future<RideHistoryResponse> fetchRideHistory(String userId) async {
    final res = await _api.postApi(
      {},
      '${AppConfig.baseUrl}URGH/GetUserRideListByUserId?UserID=$userId',
    );
    return RideHistoryResponse.fromJson(res.data);
  }

  Future<RideHistoryResponse> fetchParcelHistory(String userId) async {
    final res = await _api.postApi(
      {},
      '${AppConfig.baseUrl}URGH/GetUserRideListByUserId?UserID=$userId',
    );
    return RideHistoryResponse.fromJson(res.data);
  }
}
