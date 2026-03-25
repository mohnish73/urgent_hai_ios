import 'package:dio/dio.dart';
import '../dio_client/dio_logging_interceptor.dart';
import '../app_exceptions.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  )
    ..interceptors.add(_AuthInterceptor())
    ..interceptors.add(_ErrorInterceptor())
    ..interceptors.add(DioLoggingInterceptor());
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requiresAuth = options.extra['requiresAuth'] ?? false;
    if (requiresAuth) {
      // final token = HiveService.getToken();
      // if (token != null) {
      //   options.headers['Authorization'] = 'Bearer $token';
      // }
    }
    handler.next(options);
  }
}

/// Converts DioException HTTP errors into typed [AppException] subtypes
/// so [ApiErrorMapper] and catch blocks get a consistent, typed error.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionError:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NoInternetException(),
            type: err.type,
          ),
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const RequestTimeoutException(),
            type: err.type,
          ),
        );
      default:
        final code = err.response?.statusCode;
        if (code == 401) {
          return handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              response: err.response,
              error: const UnauthorizedException(),
              type: err.type,
            ),
          );
        }
        if (code == 403) {
          return handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              response: err.response,
              error: const ForbiddenException(),
              type: err.type,
            ),
          );
        }
        if (code != null && code >= 500) {
          return handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              response: err.response,
              error: const ServerException(),
              type: err.type,
            ),
          );
        }
        handler.next(err);
    }
  }
}
