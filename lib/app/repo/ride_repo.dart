import '../core/config/app_config.dart';
import '../model/ride/book_ride_model.dart';
import '../model/ride/ride_history_model.dart';
import '../model/ride/ride_type_model.dart';
import '../services/network/network_api_services.dart';

class RideRepo {
  final _api = NetworkApiServices();

  Future<RideTypeResponse> fetchRideTypes({
    required String userId,
    required String mobileNo,
    required String pickupAddress,
    required double pickupLat,
    required double pickupLng,
    required String dropAddress,
    required double dropLat,
    required double dropLng,
  }) async {
    final now = DateTime.now();
    final dateTime =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final res = await _api.postApi(
      {
        'userID': userId,
        'mobileNo': mobileNo,
        'pickupLocation': {
          'address': pickupAddress,
          'latitude': pickupLat,
          'longitude': pickupLng,
        },
        'dropoffLocation': {
          'address': dropAddress,
          'latitude': dropLat,
          'longitude': dropLng,
        },
        'dateTime': dateTime,
      },
      '${AppConfig.baseUrl}URGH/GetRideType',
    );
    return RideTypeResponse.fromJson(res.data);
  }

  Future<BookRideResponse> bookRide(BookRideRequestModel request) async {
    final res = await _api.postApiWithToken(
      request.toJson(),
      '${AppConfig.baseUrl}URGH/BookingRequestByUser',
    );
    return BookRideResponse.fromJson(res.data);
  }

  Future<CheckBookingResponse> checkBooking(String tempRideBookId) async {
    final res = await _api.getApiWithToken(
      '${AppConfig.baseUrl}URGH/CheckBooking?TempRideBookId=$tempRideBookId',
    );
    return CheckBookingResponse.fromJson(res.data);
  }

  Future<bool> cancelRide(String userId, int riderBook) async {
    final res = await _api.getApiWithToken(
      '${AppConfig.baseUrl}URGH/CancelRideByUser?UserID=$userId&RiderBook=$riderBook',
    );
    final json = res.data as Map<String, dynamic>;
    return json['Result'] ?? false;
  }

  Future<bool> cancelRideTemp(String userId, String tempRideBookId) async {
    final res = await _api.getApiWithToken(
      '${AppConfig.baseUrl}URGH/CancelRideFromTempFromUser?UserID=$userId&TempRideBookId=$tempRideBookId&Status=0',
    );
    final json = res.data as Map<String, dynamic>;
    return json['Result'] ?? false;
  }

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
