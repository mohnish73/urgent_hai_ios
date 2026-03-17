import '../model/auth/otp_response_model.dart';
import '../model/auth/login_response_model.dart';
import '../model/auth/signup_model.dart';
import '../services/network/network_api_services.dart';
import '../services/network/app_url.dart';

class AuthRepo {
  final _api = NetworkApiServices();

  Future<OtpResponseModel> generateOtp(String phone) async {
    final res = await _api.getApi('${AppUrl.generateOtp}?LoginId=$phone');
    return OtpResponseModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<LoginResponseModel> verifyOtp({
    required String id,
    required String otp,
    required String phone,
  }) async {
    final res = await _api.getApi(
      '${AppUrl.authenticateLogin}?Id=$id&Otp=$otp&Mobile_No=$phone',
    );
    return LoginResponseModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<SignUpResponseModel> signUp(SignUpRequestModel request) async {
    final res = await _api.postApi(request.toJson(), AppUrl.registerNewUser);
    return SignUpResponseModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<LoginResponseModel> getProfile({
    required int userId,
    required String phone,
  }) async {
    final res = await _api.getApi(
      '${AppUrl.getUserProfile}?User_Id=$userId&Mobile_No=$phone',
    );
    return LoginResponseModel.fromJson(res.data as Map<String, dynamic>);
  }
}
