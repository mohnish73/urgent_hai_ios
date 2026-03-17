import 'package:dio/dio.dart';
import '../../network/dio_client/dio_logging_interceptor.dart';
import '../../../core/storage/hive_service.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  )
    ..interceptors.add(_AuthInterceptor())
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
