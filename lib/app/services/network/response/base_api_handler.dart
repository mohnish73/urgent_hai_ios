import 'package:dio/dio.dart';
import '../app_exceptions.dart';
import 'api_response.dart';

class ApiHandler {
  static Future<ApiResponse<T>> handle<T>({
    required Future<Response<dynamic>> Function() apiCall,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await apiCall();
      final data = parser(response.data);
      return ApiResponse.success(data, statusCode: response.statusCode);
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } on AppException catch (e) {
      if (e is NoInternetException) return ApiResponse.noInternet();
      if (e is UnauthorizedException) return ApiResponse.unauthorized();
      if (e is ForbiddenException) return ApiResponse.forbidden();
      if (e is RequestTimeoutException) return ApiResponse.timeout();
      if (e is ServerException) return ApiResponse.serverError();
      return ApiResponse.error(e.message);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  static ApiResponse<T> _handleDioException<T>(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = _extractMessage(e);

    switch (e.type) {
      case DioExceptionType.connectionError:
        return ApiResponse.noInternet();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiResponse.timeout();
      case DioExceptionType.badResponse:
        if (statusCode == 401) return ApiResponse.unauthorized();
        if (statusCode == 403) return ApiResponse.forbidden();
        if (statusCode != null && statusCode >= 500) {
          return ApiResponse.serverError(message: message);
        }
        return ApiResponse.error(message!, statusCode: statusCode);
      default:
        return ApiResponse.error(message ?? 'Something went wrong.');
    }
  }

  static String? _extractMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map) {
        return data['message'] ?? data['error'] ?? data['detail'];
      }
    } catch (_) {}
    return e.message;
  }
}
