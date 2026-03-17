import 'package:dio/dio.dart';
import 'base_api_services.dart';
import 'dio_client/dio_client.dart';

class NetworkApiServices extends BaseApiServices {
  final Dio _dio = DioClient.dio;

  @override
  Future<Response<dynamic>> getApi(String url) =>
      _dio.get(url);

  @override
  Future<Response<dynamic>> getApiWithToken(String url) =>
      _dio.get(url, options: Options(extra: {'requiresAuth': true}));

  @override
  Future<Response<dynamic>> postApi(Map<String, dynamic> data, String url) =>
      _dio.post(url, data: data);

  @override
  Future<Response<dynamic>> postApiWithToken(Map<String, dynamic> data, String url) =>
      _dio.post(url, data: data, options: Options(extra: {'requiresAuth': true}));

  @override
  Future<Response<dynamic>> deleteApiWithToken(String url) =>
      _dio.delete(url, options: Options(extra: {'requiresAuth': true}));

  @override
  Future<Response<dynamic>> patchApiWithToken(Map<String, dynamic> data, String url) =>
      _dio.patch(url, data: data, options: Options(extra: {'requiresAuth': true}));

  @override
  Future<Response<dynamic>> multipartApi(String filePath, String field, String url) async {
    final formData = FormData.fromMap({
      field: await MultipartFile.fromFile(filePath),
    });
    return _dio.post(url, data: formData, options: Options(extra: {'requiresAuth': true}));
  }
}
