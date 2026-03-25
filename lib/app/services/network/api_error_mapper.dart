import 'package:dio/dio.dart';
import 'app_exceptions.dart';
import 'response/api_response.dart';

/// Maps any exception to the correct [ApiResponse] error variant.
/// Handles both typed [AppException] subtypes (thrown by _ErrorInterceptor)
/// and raw [DioException] as a fallback.
class ApiErrorMapper {
  ApiErrorMapper._();

  static ApiResponse<T> map<T>(Object e) {
    // 1. Typed AppException subtypes (set as DioException.error by _ErrorInterceptor)
    final cause = e is DioException ? e.error : e;

    if (cause is NoInternetException) return ApiResponse.noInternet();
    if (cause is RequestTimeoutException) return ApiResponse.timeout();
    if (cause is UnauthorizedException) return ApiResponse.unauthorized();
    if (cause is ForbiddenException) return ApiResponse.forbidden();
    if (cause is ServerException) return ApiResponse.serverError();
    if (cause is AppException) return ApiResponse.error(cause.toString());

    // 2. Raw DioException fallback (no typed error attached)
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
            return ApiResponse.serverError(message: e.response?.statusMessage);
          }
          return ApiResponse.error(e.message ?? 'Something went wrong. Please try again.');
      }
    }

    return ApiResponse.error('Unexpected error. Please try again.');
  }
}
