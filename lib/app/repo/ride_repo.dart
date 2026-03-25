import '../core/config/app_config.dart';
import '../model/ride/book_ride_model.dart';
import '../model/ride/ride_history_model.dart';
import '../model/ride/ride_type_model.dart';
import '../services/network/app_exceptions.dart';
import '../services/network/network_api_services.dart';
import '../services/network/response/api_response.dart';
import '../services/network/response/base_api_handler.dart';

class RideRepo {
  final _api = NetworkApiServices();

  Future<ApiResponse<List<RideTypeData>>> fetchRideTypes({
    required String userId,
    required String mobileNo,
    required String pickupAddress,
    required double pickupLat,
    required double pickupLng,
    required String dropAddress,
    required double dropLat,
    required double dropLng,
  }) {
    final now = DateTime.now();
    final dateTime =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    return ApiHandler.handle(
      apiCall: () => _api.postApi(
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
      ),
      parser: (json) {
        final res = RideTypeResponse.fromJson(json as Map<String, dynamic>);
        if (!res.result) throw AppException(res.message.isNotEmpty ? res.message : 'Failed to load ride types');
        return res.data;
      },
    );
  }

  Future<ApiResponse<BookRideData>> bookRide(BookRideRequestModel request) {
    return ApiHandler.handle(
      apiCall: () => _api.postApiWithToken(
        request.toJson(),
        '${AppConfig.baseUrl}URGH/BookingRequestByUser',
      ),
      parser: (json) {
        final res = BookRideResponse.fromJson(json as Map<String, dynamic>);
        if (!res.result || res.data == null) throw AppException(res.message.isNotEmpty ? res.message : 'Booking failed');
        return res.data!;
      },
    );
  }

  Future<ApiResponse<CheckBookingData>> checkBooking(String tempRideBookId) {
    return ApiHandler.handle(
      apiCall: () => _api.getApiWithToken(
        '${AppConfig.baseUrl}URGH/CheckBooking?TempRideBookId=$tempRideBookId',
      ),
      parser: (json) {
        final res = CheckBookingResponse.fromJson(json as Map<String, dynamic>);
        return res.data ?? CheckBookingData(isRideBook: false, bookingId: 0);
      },
    );
  }

  Future<ApiResponse<bool>> cancelRide(String userId, int riderBook) {
    return ApiHandler.handle(
      apiCall: () => _api.getApiWithToken(
        '${AppConfig.baseUrl}URGH/CancelRideByUser?UserID=$userId&RiderBook=$riderBook',
      ),
      parser: (json) => (json as Map<String, dynamic>)['Result'] as bool? ?? false,
    );
  }

  Future<ApiResponse<bool>> cancelRideTemp(String userId, String tempRideBookId) {
    return ApiHandler.handle(
      apiCall: () => _api.getApiWithToken(
        '${AppConfig.baseUrl}URGH/CancelRideFromTempFromUser?UserID=$userId&TempRideBookId=$tempRideBookId&Status=0',
      ),
      parser: (json) => (json as Map<String, dynamic>)['Result'] as bool? ?? false,
    );
  }

  Future<ApiResponse<List<RideHistoryData>>> fetchRideHistory(String userId) {
    return ApiHandler.handle(
      apiCall: () => _api.postApi(
        {},
        '${AppConfig.baseUrl}URGH/GetUserRideListByUserId?UserID=$userId',
      ),
      parser: (json) {
        final res = RideHistoryResponse.fromJson(json as Map<String, dynamic>);
        if (!res.result) throw AppException(res.message.isNotEmpty ? res.message : 'Failed to load ride history');
        return res.data;
      },
    );
  }

  Future<ApiResponse<List<RideHistoryData>>> fetchParcelHistory(String userId) {
    return ApiHandler.handle(
      apiCall: () => _api.postApi(
        {},
        '${AppConfig.baseUrl}URGH/GetUserRideListByUserId?UserID=$userId',
      ),
      parser: (json) {
        final res = RideHistoryResponse.fromJson(json as Map<String, dynamic>);
        if (!res.result) throw AppException(res.message.isNotEmpty ? res.message : 'Failed to load parcel history');
        return res.data;
      },
    );
  }
}
