import 'package:dio/dio.dart';
import '../../services/network/response/api_response.dart';

/// Maps any exception to the correct [ApiResponse] error variant.
/// Use this in every provider instead of writing switch/case manually.
class ApiErrorMapper {
  ApiErrorMapper._();

  static ApiResponse<T> map<T>(Object e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return ApiResponse.timeout();
        case DioExceptionType.connectionError:
          return ApiResponse.noInternet();
        default:
          final code = e.response?.statusCode;
          if (code == 401) return ApiResponse.unauthorized();
          if (code == 403) return ApiResponse.forbidden();
          if (code != null && code >= 500) {
            return ApiResponse.serverError(
                message: e.response?.statusMessage);
          }
          return ApiResponse.error(
              e.message ?? 'Something went wrong. Please try again.');
      }
    }
    return ApiResponse.error('Unexpected error. Please try again.');
  }
}
