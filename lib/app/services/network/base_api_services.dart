import 'package:dio/dio.dart';

abstract class BaseApiServices {
  Future<Response<dynamic>> getApi(String url);
  Future<Response<dynamic>> getApiWithToken(String url);
  Future<Response<dynamic>> postApi(Map<String, dynamic> data, String url);
  Future<Response<dynamic>> postApiWithToken(Map<String, dynamic> data, String url);
  Future<Response<dynamic>> deleteApiWithToken(String url);
  Future<Response<dynamic>> patchApiWithToken(Map<String, dynamic> data, String url);
  Future<Response<dynamic>> multipartApi(String filePath, String field, String url);
}
